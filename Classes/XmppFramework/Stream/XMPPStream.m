//-----------------------------------------------------------------------------------------------------------------------------------
#import "XMPPStream.h"
#import "AsyncSocket.h"
#import "NSXMLElementAdditions.h"
#import "NSDataAdditions.h"
#import "XMPPIQ.h"
#import "XMPPMessage.h"
#import "XMPPPresence.h"
#import "XMPPAuthorizationQuery.h"
#import "XMPPRegisterQuery.h"
#import "XMPPBind.h"
#import "XMPPAuthorize.h"
#import "XMPPSession.h"
#import "XMPPStreamFeatures.h"

//-----------------------------------------------------------------------------------------------------------------------------------
#if TARGET_OS_IPHONE
// Note: You may need to add the CFNetwork Framework to your project
#import <CFNetwork/CFNetwork.h>
#endif

// Define the various timeouts (in seconds) for retreiving various parts of the XML stream
#define TIMEOUT_WRITE         10
#define TIMEOUT_READ_START    10
#define TIMEOUT_READ_STREAM   -1

// Define the various tags we'll use to differentiate what it is we're currently reading or writing
#define TAG_WRITE_START      100
#define TAG_WRITE_STREAM     101

#define TAG_READ_START       200
#define TAG_READ_STREAM      201

// Define the various states we'll use to track our progress
#define STATE_DISCONNECTED     0
#define STATE_CONNECTING       1
#define STATE_OPENING          2
#define STATE_NEGOTIATING      3
#define STATE_STARTTLS         4
#define STATE_REGISTERING      5
#define STATE_AUTH_1           6
#define STATE_AUTH_2           7
#define STATE_BINDING          8
#define STATE_START_SESSION    9
#define STATE_CONNECTED       10


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPStream

//-----------------------------------------------------------------------------------------------------------------------------------
@synthesize state;
@synthesize isSecure;
@synthesize isAuthenticated;
@synthesize allowsSelfSignedCertificates;
@synthesize delegate;
@synthesize asyncSocket;
@synthesize serverHostName;
@synthesize xmppHostName;
@synthesize buffer;
@synthesize rootElement;
@synthesize terminator;
@synthesize authUsername;
@synthesize authResource;
@synthesize tempPassword;
@synthesize keepAliveTimer;

//===================================================================================================================================
#pragma mark XMPPStream

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)init {
	return [self initWithDelegate:nil];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (id)initWithDelegate:(id)aDelegate {
	if(self = [super init]) {
		// Store reference to delegate
		self.delegate = aDelegate;
		
		// Initialize state and socket
		self.state = STATE_DISCONNECTED;
		self.asyncSocket = [[AsyncSocket alloc] initWithDelegate:self];
		
		// Enable pre-buffering on the socket to improve readDataToData performance
		[self.asyncSocket enablePreBuffering];
		
		// Initialize configuration
		self.isSecure = NO;
		self.isAuthenticated = NO;
		self.allowsSelfSignedCertificates = NO;
		
		// We initialize an empty buffer of data to store data as it arrives
		self.buffer = [[NSMutableData alloc] initWithCapacity:100];
		
		// Initialize the standard terminator to listen for
		// We try to parse the data everytime we encouter an XML ending tag character
		self.terminator = [[@">" dataUsingEncoding:NSUTF8StringEncoding] retain];
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[self.asyncSocket setDelegate:nil];
	[self.asyncSocket disconnect];
	[self.asyncSocket release];
	[self.xmppHostName release];
	[self.buffer release];
	[self.rootElement release];
	[self.terminator release];
	[self.authUsername release];
	[self.authResource release];
	[self.tempPassword release];
	[self.keepAliveTimer invalidate];
	[self.keepAliveTimer release];
	[super dealloc];
}

//===================================================================================================================================
#pragma mark Configuration

//===================================================================================================================================
#pragma mark Connection Methods

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isDisconnected {
	return (self.state == STATE_DISCONNECTED);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)isConnected {
	return (self.state == STATE_CONNECTED);
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)connectToHost:(NSString *)hostName onPort:(UInt16)portNumber withVirtualHost:(NSString *)vHostName secure:(BOOL)secure {    
	if(self.state == STATE_DISCONNECTED) {
		// Store configuration information
		self.isSecure = secure;
		self.isAuthenticated = NO;
		
		self.serverHostName = hostName;
		self.xmppHostName = vHostName;
		
		// Update state
		// Note that we do this before connecting to the host,
		// because the delegate methods will be called before the method returns
		self.state = STATE_CONNECTING;
		
		// If the given port number is zero, use the default port number for XMPP communication
		UInt16 myPortNumber = (portNumber > 0) ? portNumber : (secure ? 5223 : 5222);
		
		// Connect to the host
		[self.asyncSocket connectToHost:hostName onPort:myPortNumber error:nil];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)connectToHost:(NSString *)hostName onPort:(UInt16)portNumber withVirtualHost:(NSString *)vHostName {
	[self connectToHost:hostName onPort:portNumber withVirtualHost:vHostName secure:NO];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)connectToSecureHost:(NSString *)hostName onPort:(UInt16)portNumber withVirtualHost:(NSString *)vHostName {
	[self connectToHost:hostName onPort:portNumber withVirtualHost:vHostName secure:YES];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)disconnect {
	[self.asyncSocket disconnect];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)disconnectAfterSending {
	[self.asyncSocket disconnectAfterWriting];
}

//===================================================================================================================================
#pragma mark User Registration

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)supportsInBandRegistration {
	if(self.state == STATE_CONNECTED) {
		return ([[self streamFeatures] supportsInBandRegistration]);
	}
	return NO;
}

//===================================================================================================================================
#pragma mark User Authentication

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)supportsPlainAuthentication {
    return [[self streamFeatures] supportsPlainAuthentication];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)supportsDigestMD5Authentication {
    return [[self streamFeatures] supportsDigestMD5Authentication];
	return NO;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)authenticateUser:(NSString*)username withPassword:(NSString*)password resource:(NSString*)resource {
	if(self.state == STATE_CONNECTED)
	{
		if([self supportsDigestMD5Authentication]) {
            XMPPAuthorize* auth = [[XMPPAuthorize alloc] initWithMechanism:@"DIGEST-MD5"];			
			if(DEBUG) {
				NSLog(@"SEND: %@", auth);
			}
			[self.asyncSocket writeData:[[auth XMLString] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];			
			self.tempPassword = password;
		}
		else if([self supportsPlainAuthentication]) {
			NSString* payload = [NSString stringWithFormat:@"%C%@%C%@", 0, username, 0, password];
			NSString* base64 = [[payload dataUsingEncoding:NSUTF8StringEncoding] base64Encoded];			
            XMPPAuthorize* auth = [[XMPPAuthorize alloc] initWithMechanism:@"PLAIN" andPlainCredentials:base64];			
			if(DEBUG) {
				NSLog(@"SEND: %@", [auth XMLString]);
			}
			[self.asyncSocket writeData:[[auth XMLString] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];
		} else {
			NSString *rootID = [[self.rootElement attributeForName:@"id"] stringValue];
			NSString *digestStr = [NSString stringWithFormat:@"%@%@", rootID, password];
			NSData *digestData = [digestStr dataUsingEncoding:NSUTF8StringEncoding];			
			NSString *digest = [[digestData sha1Digest] hexStringValue];			
            XMPPIQ* auth = [[XMPPIQ alloc] initWithType:@"set"];
            [auth addQuery:[[XMPPAuthorizationQuery alloc] initWithUsername:username digest:digest andResource:resource]];			
			if(DEBUG) {
				NSLog(@"SEND: %@", [auth XMLString]);
			}
			[self.asyncSocket writeData:[[auth XMLString] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];
        }
        self.authUsername = username;
        self.authResource = resource;
        self.state = STATE_AUTH_1;        
	}
}

//===================================================================================================================================
#pragma mark General Methods

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSXMLElement*)streamFeaturesAsElement {
    return 	[self.rootElement elementForName:@"stream:features"];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (XMPPStreamFeatures*)streamFeatures {
    return [XMPPStreamFeatures createFromElement:[self streamFeaturesAsElement]]; 
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (float)serverXmppStreamVersionNumber {
	return [[[self.rootElement attributeForName:@"version"] stringValue] floatValue];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)sendElement:(NSXMLElement *)element {
	if(self.state == STATE_CONNECTED)
	{
		NSString *elementStr = [element XMLString];
		
		if(DEBUG) {
			NSLog(@"SEND: %@", elementStr);
		}
		[self.asyncSocket writeData:[elementStr dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];
	}
}

//===================================================================================================================================
#pragma mark Stream Negotiation

//-----------------------------------------------------------------------------------------------------------------------------------
/**
 * This method handles sending the opening <stream:stream ...> element which is needed in several situations.
**/
- (void)sendOpeningNegotiation {
	if(self.state == STATE_CONNECTING) {
		// TCP connection was just opened - We need to include the opening XML stanza
		NSString *s1 = @"<?xml version='1.0'?>";
		
		if(DEBUG) {
			NSLog(@"SEND: %@", s1);
		}
		[self.asyncSocket writeData:[s1 dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_START];
	}
	
	NSString *xmlns = @"jabber:client";
	NSString *xmlns_stream = @"http://etherx.jabber.org/streams";
	
	NSString *temp, *s2;
	if([self.xmppHostName length] > 0) {
		temp = @"<stream:stream xmlns='%@' xmlns:stream='%@' version='1.0' to='%@'>";
		s2 = [NSString stringWithFormat:temp, xmlns, xmlns_stream, self.xmppHostName];
	}
	else {
		temp = @"<stream:stream xmlns='%@' xmlns:stream='%@' version='1.0'>";
		s2 = [NSString stringWithFormat:temp, xmlns, xmlns_stream];
	}
	
	if(DEBUG) {
		NSLog(@"SEND: %@", s2);
	}
	[self.asyncSocket writeData:[s2 dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_START];
	
	// Update status
	self.state = STATE_OPENING;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleStreamFeatures {
	
    if([[self streamFeatures] requiresTLS]) {
        self.state = STATE_STARTTLS;        
        NSString *starttls = @"<starttls xmlns='urn:ietf:params:xml:ns:xmpp-tls'/>";        
        if(DEBUG) {
            NSLog(@"SEND: %@", starttls);
        }
        [self.asyncSocket writeData:[starttls dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];
        return;
    }
		
	if([[self streamFeatures] requiresBind]) {
		self.state = STATE_BINDING;		
		if([self.authResource length] > 0) {
            XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set"];
            [iq addBind:[[XMPPBind alloc] initWithResource:self.authResource]];
			if(DEBUG) {
				NSLog(@"SEND: %@", iq);
			}
			[self.asyncSocket writeData:[[iq XMLString] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];
		} else {
            XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set"];
            [iq addBind:[[XMPPBind alloc] init]];						
			if(DEBUG) {
				NSLog(@"SEND: %@", iq);
			}
			[self.asyncSocket writeData:[[iq XMLString] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];
		}
		return;
	}

	self.state = STATE_CONNECTED;	
	if(!self.isAuthenticated) {
		[self.keepAliveTimer invalidate];
		self.keepAliveTimer = [[NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(keepAlive:) userInfo:nil repeats:YES] retain];
		if([self.delegate respondsToSelector:@selector(xmppStreamDidOpen:)]) {
			[self.delegate xmppStreamDidOpen:self];
		}
		else if(DEBUG) {
			NSLog(@"xmppStreamDidOpen:%p", self);
		}
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleStartTLSResponse:(NSXMLElement *)response {
	// We're expecting a proceed response
	// If we get anything else we can safely assume it's the equivalent of a failure response
	if(![[response name] isEqualToString:@"proceed"]) {
		// We can close our TCP connection now
		[self disconnect];
		
		// The onSocketDidDisconnect: method will handle everything else
		return;
	}
	
	// Connecting to a secure server
	NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
	
	// Use the highest possible security
	[settings setObject:(NSString *)kCFStreamSocketSecurityLevelNegotiatedSSL forKey:(NSString *)kCFStreamSSLLevel];
	
	// Set the peer name
	[settings setObject:self.xmppHostName forKey:(NSString *)kCFStreamSSLPeerName];
	
	// Allow self-signed certificates if needed
	if(self.allowsSelfSignedCertificates) {
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	CFReadStreamSetProperty([self.asyncSocket getCFReadStream], kCFStreamPropertySSLSettings, (CFDictionaryRef)settings);
	CFWriteStreamSetProperty([self.asyncSocket getCFWriteStream], kCFStreamPropertySSLSettings, (CFDictionaryRef)settings);
	
	// Make a note of the switch to TLS
	self.isSecure = YES;
	
	// Now we start our negotiation over again...
	[self sendOpeningNegotiation];
}

//-----------------------------------------------------------------------------------------------------------------------------------
/**
 * After the registerUser:withPassword: method is invoked, a registration message is sent to the server.
 * We're waiting for the result from this registration request.
**/
- (void)handleRegistration:(NSXMLElement *)response {
	if([[[response attributeForName:@"type"] stringValue] isEqualToString:@"error"])
	{
		// Revert back to connected state (from authenticating state)
		self.state = STATE_CONNECTED;
		
		if([self.delegate respondsToSelector:@selector(xmppStream:didNotRegister:)]) {
			[self.delegate xmppStream:self didNotRegister:response];
		}
		else if(DEBUG) {
			NSLog(@"xmppStream:%p didNotRegister:%@", self, [response XMLString]);
		}
	}
	else
	{
		// Revert back to connected state (from authenticating state)
		self.state = STATE_CONNECTED;
		
		if([self.delegate respondsToSelector:@selector(xmppStreamDidRegister:)]) {
			[self.delegate xmppStreamDidRegister:self];
		}
		else if(DEBUG) {
			NSLog(@"xmppStreamDidRegister:%p", self);
		}
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
/**
 * After the authenticateUser:withPassword:resource method is invoked, a authentication message is sent to the server.
 * If the server supports digest-md5 sasl authentication, it is used.  Otherwise plain sasl authentication is used,
 * assuming the server supports it.
 * 
 * Now if digest-md5 was used, we sent a challenge request, and we're waiting for a challenge response.
 * If plain sasl was used, we sent our authentication information, and we're waiting for a success response.
**/
- (void)handleAuth1:(NSXMLElement *)response {
	if([self supportsDigestMD5Authentication])
	{
		// We're expecting a challenge response
		// If we get anything else we can safely assume it's the equivalent of a failure response
		if(![[response name] isEqualToString:@"challenge"]) {
			// Revert back to connected state (from authenticating state)
			self.state = STATE_CONNECTED;
			
			if([self.delegate respondsToSelector:@selector(xmppStream:didNotAuthenticate:)]) {
				[self.delegate xmppStream:self didNotAuthenticate:response];
			}
			else if(DEBUG) {
				NSLog(@"xmppStream:%p didNotAuthenticate:%@", self, [response XMLString]);
			}
		}
		else {
			// Create authentication object from the given challenge
			// We'll release this object at the end of this else block
			XMPPDigestAuthentication *auth = [[XMPPDigestAuthentication alloc] initWithChallenge:response];
			
			// Sometimes the realm isn't specified
			// In this case I believe the realm is implied as the virtual host name
			if(![auth realm])
				[auth setRealm:self.xmppHostName];
			
			// Set digest-uri
			[auth setDigestURI:[NSString stringWithFormat:@"xmpp/%@", self.xmppHostName]];
			
			// Set username and password
			[auth setUsername:self.authUsername password:self.tempPassword];
			
			// Create and send challenge response element
			NSXMLElement *cr = [NSXMLElement elementWithName:@"response" xmlns:@"urn:ietf:params:xml:ns:xmpp-sasl"];
			[cr setStringValue:[auth base64EncodedFullResponse]];
			
			if(DEBUG) {
				NSLog(@"SEND: %@", [cr XMLString]);
			}
			[self.asyncSocket writeData:[[cr XMLString] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];
			
			// Release unneeded resources
			[auth release];
			self.tempPassword = nil;
			
			// Update state
			self.state = STATE_AUTH_2;
		}
	}
	else if([self supportsPlainAuthentication]) {
		// We're expecting a success response
		// If we get anything else we can safely assume it's the equivalent of a failure response
		if(![[response name] isEqualToString:@"success"])
		{
			// Revert back to connected state (from authenticating state)
			self.state = STATE_CONNECTED;
			
			if([self.delegate respondsToSelector:@selector(xmppStream:didNotAuthenticate:)]) {
				[self.delegate xmppStream:self didNotAuthenticate:response];
			}
			else if(DEBUG) {
				NSLog(@"xmppStream:%p didNotAuthenticate:%@", self, [response XMLString]);
			}
		}
		else {
			// We are successfully authenticated (via sasl:plain)
			self.isAuthenticated = YES;
			
			// Now we start our negotiation over again...
			[self sendOpeningNegotiation];
		}
	}
	else {
		// We used the old fashioned jabber:iq:auth mechanism
		
		if([[[response attributeForName:@"type"] stringValue] isEqualToString:@"error"]) {
			// Revert back to connected state (from authenticating state)
			self.state = STATE_CONNECTED;
			
			if([self.delegate respondsToSelector:@selector(xmppStream:didNotAuthenticate:)]) {
				[self.delegate xmppStream:self didNotAuthenticate:response];
			}
			else if(DEBUG) {
				NSLog(@"xmppStream:%p didNotAuthenticate:%@", self, [response XMLString]);
			}
		}
		else {
			// We are successfully authenticated (via non-sasl:digest)
			// And we've binded our resource as well
			self.isAuthenticated = YES;
			
			// Revert back to connected state (from authenticating state)
			self.state = STATE_CONNECTED;
			
			if([self.delegate respondsToSelector:@selector(xmppStreamDidAuthenticate:)]) {
				[self.delegate xmppStreamDidAuthenticate:self];
			}
			else if(DEBUG) {
				NSLog(@"xmppStreamDidAuthenticate:%p", self);
			}
		}
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
/**
 * This method handles the result of our challenge response we sent in handleAuth1 using digest-md5 sasl.
**/
- (void)handleAuth2:(NSXMLElement *)response {
	if([[response name] isEqualToString:@"challenge"]) {
		XMPPDigestAuthentication *auth = [[[XMPPDigestAuthentication alloc] initWithChallenge:response] autorelease];
		
		if(![auth rspauth]) {
			// We're getting another challenge???
			// I'm not sure what this could possibly be, so for now I'll assume it's a failure
			
			// Revert back to connected state (from authenticating state)
			self.state = STATE_CONNECTED;
			
			if([self.delegate respondsToSelector:@selector(xmppStream:didNotAuthenticate:)]) {
				[self.delegate xmppStream:self didNotAuthenticate:response];
			}
			else if(DEBUG) {
				NSLog(@"xmppStream:%p didNotAuthenticate:%@", self, [response XMLString]);
			}
		}
		else {
			// We received another challenge, but it's really just an rspauth
			// This is supposed to be included in the success element (according to the updated RFC)
			// but many implementations incorrectly send it inside a second challenge request.
			
			// Create and send empty challenge response element
			NSXMLElement *cr = [NSXMLElement elementWithName:@"response" xmlns:@"urn:ietf:params:xml:ns:xmpp-sasl"];
			
			if(DEBUG) {
				NSLog(@"SEND: %@", [cr XMLString]);
			}
			[self.asyncSocket writeData:[[cr XMLString] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];
			
			// The state remains in STATE_AUTH_2
		}
	}
	else if([[response name] isEqualToString:@"success"]) {
		// We are successfully authenticated (via sasl:digest-md5)
		self.isAuthenticated = YES;
		
		// Now we start our negotiation over again...
		[self sendOpeningNegotiation];
	}
	else {
		// We received some kind of <failure/> element
		
		// Revert back to connected state (from authenticating state)
		self.state = STATE_CONNECTED;
		
		if([self.delegate respondsToSelector:@selector(xmppStream:didNotAuthenticate:)]) {
			[self.delegate xmppStream:self didNotAuthenticate:response];
		}
		else if(DEBUG) {
			NSLog(@"xmppStream:%p didNotAuthenticate:%@", self, [response XMLString]);
		}
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleBinding:(NSXMLElement *)response {
	NSXMLElement *r_bind = [response elementForName:@"bind"];
	NSXMLElement *r_jid = [r_bind elementForName:@"jid"];
	
	if(r_jid) {
		NSString *fullJID = [r_jid stringValue];
		self.authResource = [[fullJID lastPathComponent] copy];
        XMPPStreamFeatures* features = [XMPPStreamFeatures createFromElement:[self streamFeatures]]; 
		if([features supportsSession])
		{
            XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set"];
            [iq addSession:[[XMPPSession alloc] init]];
			if(DEBUG) {
				NSLog(@"SEND: %@", iq);
			}
			[self.asyncSocket writeData:[[iq XMLString] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];
			
			// Update state
			self.state = STATE_START_SESSION;
		}
		else {
			// Revert back to connected state (from binding state)
			self.state = STATE_CONNECTED;
			
			if([self.delegate respondsToSelector:@selector(xmppStreamDidAuthenticate:)]) {
				[self.delegate xmppStreamDidAuthenticate:self];
			}
			else if(DEBUG) {
				NSLog(@"xmppStreamDidAuthenticate:%p", self);
			}
		}
	}
	else {
		// It appears the server didn't allow our resource choice
		// We'll simply let the server choose then
		
        XMPPIQ* iq = [[XMPPIQ alloc] initWithType:@"set"];
        [iq addBind:[[XMPPBind alloc] init]];
		if(DEBUG) {
			NSLog(@"SEND: %@", iq);
		}
		[self.asyncSocket writeData:[[iq XMLString] dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];
		
		// The state remains in STATE_BINDING
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)handleStartSessionResponse:(NSXMLElement *)response {
	if([[[response attributeForName:@"type"] stringValue] isEqualToString:@"result"]) {
		// Revert back to connected state (from start session state)
		self.state = STATE_CONNECTED;
		
		if([self.delegate respondsToSelector:@selector(xmppStreamDidAuthenticate:)]) {
			[self.delegate xmppStreamDidAuthenticate:self];
		}
		else if(DEBUG) {
			NSLog(@"xmppStreamDidAuthenticate:%p", self);
		}
	}
	else {
		// Revert back to connected state (from start session state)
		self.state = STATE_CONNECTED;
		
		if([self.delegate respondsToSelector:@selector(xmppStream:didNotAuthenticate:)]) {
			[self.delegate xmppStream:self didNotAuthenticate:response];
		}
		else if(DEBUG) {
			NSLog(@"xmppStream:%p didNotAuthenticate:%@", self, [response XMLString]);
		}
	}
}

//===================================================================================================================================
#pragma mark AsyncSocket Delegate Methods

//-----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)onSocketWillConnect:(AsyncSocket *)sock {
	if(self.isSecure)
	{
		// Connecting to a secure server
		NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
		
		// Use the highest possible security
		[settings setObject:(NSString *)kCFStreamSocketSecurityLevelNegotiatedSSL forKey:(NSString *)kCFStreamSSLLevel];
		
		// Set the peer name
		[settings setObject:self.xmppHostName forKey:(NSString *)kCFStreamSSLPeerName];
		
		// Allow self-signed certificates if needed
		if(self.allowsSelfSignedCertificates) {
			[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
		}
		
		CFReadStreamSetProperty([self.asyncSocket getCFReadStream], kCFStreamPropertySSLSettings, (CFDictionaryRef)settings);
		CFWriteStreamSetProperty([self.asyncSocket getCFWriteStream], kCFStreamPropertySSLSettings, (CFDictionaryRef)settings);
	}
	return YES;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	[self sendOpeningNegotiation];
	[self.asyncSocket readDataToData:self.terminator withTimeout:TIMEOUT_READ_START tag:TAG_READ_START];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag {
	NSString *dataAsStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	if(DEBUG) {
		NSLog(@"RECV: %@", dataAsStr);
	}
	
	if(self.state == STATE_OPENING) {
		// Could be either one of the following:
		// <?xml ...>
		// <stream:stream ...>
		
		[self.buffer appendData:data];
		
		if([dataAsStr hasSuffix:@"?>"]) {
			// We read in the <?xml version='1.0'?> line
			// We need to keep reading for the <stream:stream ...> line
			[self.asyncSocket readDataToData:self.terminator withTimeout:TIMEOUT_READ_START tag:TAG_READ_START];
		} else {
			// At this point we've sent our XML stream header, and we've received the response XML stream header.
			// We save the root element of our stream for future reference.
			// We've kept everything up to this point in our buffer, so all we need to do is close the stream:stream
			// tag to allow us to parse the data as a valid XML document.
			// Digest Access authentication requires us to know the ID attribute from the <stream:stream/> element.
			
			[self.buffer appendData:[@"</stream:stream>" dataUsingEncoding:NSUTF8StringEncoding]];
			
			NSXMLDocument* xmlDoc = [[[NSXMLDocument alloc] initWithData:self.buffer options:0 error:nil] autorelease];
			
			self.rootElement = [xmlDoc rootElement];
			
			[self.buffer setLength:0];
			
			// Check for RFC compliance
			if([self serverXmppStreamVersionNumber] >= 1.0) {
				// Update state - we're now onto stream negotiations
				self.state = STATE_NEGOTIATING;
				
				// We need to read in the stream features now
				[self.asyncSocket readDataToData:self.terminator withTimeout:TIMEOUT_READ_STREAM tag:TAG_READ_STREAM];
			}
			else {
				// The server isn't RFC comliant, and won't be sending any stream features
				
				// Update state - we're connected now
				self.state = STATE_CONNECTED;
				
				// Continue reading for XML fragments
				[self.asyncSocket readDataToData:self.terminator withTimeout:TIMEOUT_READ_STREAM tag:TAG_READ_STREAM];
				
				// Notify delegate
				if([self.delegate respondsToSelector:@selector(xmppStreamDidOpen:)]) {
					[self.delegate xmppStreamDidOpen:self];
				}
				else if(DEBUG) {
					NSLog(@"xmppStreamDidOpen:%p", self);
				}
			}
		}
		return;
	}
	
	// We encountered the end of some tag. IE - we found a ">" character.
	
	// Is it the end of the stream?
	if([dataAsStr hasSuffix:@"</stream:stream>"]) {
		// We can close our TCP connection now
		[self disconnect];
		
		return;
	}
	
	// Add the given data to our buffer, and try parsing the data
	// If the parsing works, we have found an entire XML message fragment.
	
	// Work-around for problem in NSXMLDocument parsing
	// The parser doesn't like <stream:X> tags unless they're properly namespaced
	// This namespacing is declared in the opening <stream:stream> tag, but we only parse individual elements
	if([dataAsStr isEqualToString:@"<stream:features>"]) {
		NSString *fix = @"<stream:features xmlns:stream='http://etherx.jabber.org/streams'>";
		[self.buffer appendData:[fix dataUsingEncoding:NSUTF8StringEncoding]];
	}
	else if([dataAsStr isEqualToString:@"<stream:error>"]) {
		NSString *fix = @"<stream:error xmlns:stream='http://etherx.jabber.org/streams'>";
		[self.buffer appendData:[fix dataUsingEncoding:NSUTF8StringEncoding]];
	}
	else {
		[self.buffer appendData:data];
	}
	
	NSXMLDocument *xmlDoc = [[[NSXMLDocument alloc] initWithData:self.buffer options:0 error:nil] autorelease];
	
	if(!xmlDoc) {
		// We don't have a full XML message fragment yet
		// Keep reading data from the stream until we get a full fragment
		[self.asyncSocket readDataToData:self.terminator withTimeout:TIMEOUT_READ_STREAM tag:TAG_READ_STREAM];
		return;
	}
	
	NSXMLElement* element = [xmlDoc rootElement];
	
	if(self.state == STATE_NEGOTIATING) {
		[element detach];
		[self.rootElement setChildren:[NSArray arrayWithObject:element]];
        [self handleStreamFeatures];
	}
	else if(self.state == STATE_STARTTLS) {
		[self handleStartTLSResponse:element];
	}
	else if(self.state == STATE_REGISTERING) {
		[self handleRegistration:element];
	}
	else if(self.state == STATE_AUTH_1) {
		[self handleAuth1:element];
	}
	else if(self.state == STATE_AUTH_2) {
		[self handleAuth2:element];
	}
	else if(self.state == STATE_BINDING) {
		[self handleBinding:element];
	}
	else if(self.state == STATE_START_SESSION) {
		[self handleStartSessionResponse:element];
	}
	else if([[element name] isEqualToString:@"iq"]) {
		if([self.delegate respondsToSelector:@selector(xmppStream:didReceiveIQ:)]) {
			[self.delegate xmppStream:self didReceiveIQ:[XMPPIQ createFromElement:element]];
		}
		else if(DEBUG) {
			NSLog(@"xmppStream:%p didReceiveIQ:%@", self, [element XMLString]);
		}
	}
	else if([[element name] isEqualToString:@"message"]) {
		if([self.delegate respondsToSelector:@selector(xmppStream:didReceiveMessage:)]) {
			[self.delegate xmppStream:self didReceiveMessage:[XMPPMessage createFromElement:element]];
		}
		else if(DEBUG) {
			NSLog(@"xmppStream:%p didReceiveMessage:%@", self, [element XMLString]);
		}
	}
	else if([[element name] isEqualToString:@"presence"]) {
		if([self.delegate respondsToSelector:@selector(xmppStream:didReceivePresence:)]) {
			[self.delegate xmppStream:self didReceivePresence:[XMPPPresence createFromElement:element]];
		}
		else if(DEBUG) {
			NSLog(@"xmppStream:%p didReceivePresence:%@", self, [element XMLString]);
		}
	}
	else {
		if([self.delegate respondsToSelector:@selector(xmppStream:didReceiveError:)]) {
			[self.delegate xmppStream:self didReceiveError:element];
		}
		else if(DEBUG) {
			NSLog(@"xmppStream:%p didReceiveError:%@", self, [element XMLString]);
		}
	}
	
	[self.buffer setLength:0];
	
	if([self.asyncSocket isConnected]) {
		[self.asyncSocket readDataToData:self.terminator withTimeout:TIMEOUT_READ_STREAM tag:TAG_READ_STREAM];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	if((tag != TAG_WRITE_STREAM) && (tag != TAG_WRITE_START)) {
		if([self.delegate respondsToSelector:@selector(xmppStream:didSendElementWithTag:)])
		{
			[self.delegate xmppStream:self didSendElementWithTag:tag];
		}
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
	if([self.delegate respondsToSelector:@selector(xmppStream:didReceiveError:)]) {
		[self.delegate xmppStream:self didReceiveError:err];
	}
	else if(DEBUG) {
		NSLog(@"xmppStream:%p didReceiveError:%@", self, err);
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
	// Update state
	self.state = STATE_DISCONNECTED;
	
	// Update configuration
	self.isSecure = NO;
	self.isAuthenticated = NO;
	
	// Clear the buffer
	[self.buffer setLength:0];
	
	// Clear the root element
	self.rootElement = nil;
	
	// Clear any saved authentication information
	self.authUsername = nil;
	self.authResource = nil;
	self.tempPassword = nil;
	
	// Stop the keep alive timer
	[keepAliveTimer invalidate];
	self.keepAliveTimer = nil;
	
	// Notify delegate
	if([self.delegate respondsToSelector:@selector(xmppStreamDidClose:)]) {
		[self.delegate xmppStreamDidClose:self];
	}
	else if(DEBUG) {
		NSLog(@"xmppStreamDidClose:%p", self);
	}
}

//===================================================================================================================================
#pragma mark Helper Methods

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)keepAlive:(NSTimer *)aTimer {
	if(self.state == STATE_CONNECTED) {
		[self.asyncSocket writeData:[@" "dataUsingEncoding:NSUTF8StringEncoding] withTimeout:TIMEOUT_WRITE tag:TAG_WRITE_STREAM];
	}
}

@end

//===================================================================================================================================
#pragma mark -

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation XMPPDigestAuthentication

//===================================================================================================================================
#pragma mark XMPPDigestAuthentication

- (id)initWithChallenge:(NSXMLElement *)challenge {
	if(self = [super init])
	{
		// Convert the base 64 encoded data into a string
		NSData *base64Data = [[challenge stringValue] dataUsingEncoding:NSASCIIStringEncoding];
		NSData *decodedData = [base64Data base64Decoded];
		
		NSString *authStr = [[[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding] autorelease];
		
		if(DEBUG) {
			NSLog(@"decoded challenge: %@", authStr);
		}
		
		// Extract all the key=value pairs, and put them in a dictionary for easy lookup
		NSMutableDictionary *auth = [NSMutableDictionary dictionaryWithCapacity:5];
		
		NSArray *components = [authStr componentsSeparatedByString:@","];
		
		int i;
		for(i = 0; i < [components count]; i++)
		{
			NSString *component = [components objectAtIndex:i];
			
			NSRange separator = [component rangeOfString:@"="];
			if(separator.location != NSNotFound)
			{
				NSString *key = [component substringToIndex:separator.location];
				NSString *value = [component substringFromIndex:separator.location+1];
				
				if([value hasPrefix:@"\""] && [value hasSuffix:@"\""] && [value length] > 2)
				{
					// Strip quotes from value
					value = [value substringWithRange:NSMakeRange(1,([value length]-2))];
				}
				
				[auth setObject:value forKey:key];
			}
		}
		
		// Extract and retain the elements we need
		rspauth = [[auth objectForKey:@"rspauth"] copy];
		realm = [[auth objectForKey:@"realm"] copy];
		nonce = [[auth objectForKey:@"nonce"] copy];
		qop = [[auth objectForKey:@"qop"] copy];
		
		// Generate cnonce
		CFUUIDRef theUUID = CFUUIDCreate(NULL);
		cnonce = (NSString *)CFUUIDCreateString(NULL, theUUID);
		CFRelease(theUUID);
	}
	return self;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
	[rspauth release];
	[realm release];
	[nonce release];
	[qop release];
	[username release];
	[password release];
	[cnonce release];
	[nc release];
	[digestURI release];
	[super dealloc];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString *)rspauth {
	return [[rspauth copy] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString *)realm {
	return [[realm copy] autorelease];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setRealm:(NSString *)newRealm {
	if(![realm isEqual:newRealm])
	{
		[realm release];
		realm = [newRealm copy];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setDigestURI:(NSString *)newDigestURI {
	if(![digestURI isEqual:newDigestURI])
	{
		[digestURI release];
		digestURI = [newDigestURI copy];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)setUsername:(NSString *)newUsername password:(NSString *)newPassword {
	if(![username isEqual:newUsername])
	{
		[username release];
		username = [newUsername copy];
	}
	
	if(![password isEqual:newPassword])
	{
		[password release];
		password = [newPassword copy];
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString *)response {
	NSString *HA1str = [NSString stringWithFormat:@"%@:%@:%@", username, realm, password];
	NSString *HA2str = [NSString stringWithFormat:@"AUTHENTICATE:%@", digestURI];
	
	NSData *HA1dataA = [[HA1str dataUsingEncoding:NSUTF8StringEncoding] md5Digest];
	NSData *HA1dataB = [[NSString stringWithFormat:@":%@:%@", nonce, cnonce] dataUsingEncoding:NSUTF8StringEncoding];
	
	NSMutableData *HA1data = [NSMutableData dataWithCapacity:([HA1dataA length] + [HA1dataB length])];
	[HA1data appendData:HA1dataA];
	[HA1data appendData:HA1dataB];
	
	NSString *HA1 = [[HA1data md5Digest] hexStringValue];
	
	NSString *HA2 = [[[HA2str dataUsingEncoding:NSUTF8StringEncoding] md5Digest] hexStringValue];
	
	NSString *responseStr = [NSString stringWithFormat:@"%@:%@:00000001:%@:auth:%@",
		HA1, nonce, cnonce, HA2];
	
	NSString *response = [[[responseStr dataUsingEncoding:NSUTF8StringEncoding] md5Digest] hexStringValue];
	
	return response;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString *)base64EncodedFullResponse {
	NSMutableString* localBuffer = [NSMutableString stringWithCapacity:100];
	[localBuffer appendFormat:@"username=\"%@\",", username];
	[localBuffer appendFormat:@"realm=\"%@\",", realm];
	[localBuffer appendFormat:@"nonce=\"%@\",", nonce];
	[localBuffer appendFormat:@"cnonce=\"%@\",", cnonce];
	[localBuffer appendFormat:@"nc=00000001,"];
	[localBuffer appendFormat:@"qop=auth,"];
	[localBuffer appendFormat:@"digest-uri=\"%@\",", digestURI];
	[localBuffer appendFormat:@"response=%@,", [self response]];
	[localBuffer appendFormat:@"charset=utf-8"];
	
	if(DEBUG) {
		NSLog(@"decoded response: %@", localBuffer);
	}
	
	NSData* utf8data = [localBuffer dataUsingEncoding:NSUTF8StringEncoding];
	
	return [utf8data base64Encoded];
}

@end
