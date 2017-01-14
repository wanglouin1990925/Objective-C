//
//  YYYCommunication.m
//  CruiseShip
//
//  Created by Yang Dandan on 25/10/13.
//  Copyright (c) 2013 Yang. All rights reserved.
//

#import "YYYCommunication.h"
#import "YYYAppDelegate.h"

#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import <AVFoundation/AVFoundation.h>

#define WEBAPI_SIGNUP				@"/signup.php"
#define WEBAPI_USERS				@"/loadusers.php"
#define WEBAPI_LOADUSERPROFILE		@"/loaduserprofile.php"
#define WEBAPI_RATEUSER				@"/rateuser.php"
#define WEBAPI_VOTE					@"/vote.php"
#define WEBAPI_COMMENT				@"/comment.php"
#define WEBAPI_GETNOTIFICATIONS		@"/getnotifications.php"
#define WEBAPI_SENDFEEDBACK			@"/sendfeedback.php"
#define WEBAPI_TRENDING				@"/loadtrend.php"
#define WEBAPI_RATEFBUSER			@"/ratefbuser.php"

@implementation YYYCommunication

@synthesize me ;

// Functions ;
#pragma mark - Shared Functions
+ ( YYYCommunication* ) sharedManager
{
    __strong static YYYCommunication* sharedObject = nil ;
	static dispatch_once_t onceToken ;
    
	dispatch_once( &onceToken, ^{
        sharedObject = [ [ YYYCommunication alloc ] init ] ;
	} ) ;
    
    return sharedObject ;
}

#pragma mark - SocialCommunication
- ( id ) init
{
    self = [ super init ] ;
    
    if( self )
    {
        // Location ;
        [ self setMe : nil ] ;
		[ self setLstNotification : nil ];
    }
    
    return self ;
}

#pragma mark - Web Service 2.0

- ( void ) sendToService : ( NSDictionary* ) _params
                  action : ( NSString* ) _action
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure
{
	NSString *strUrl = [NSString stringWithFormat:@"%@%@",WEBAPI_URL,_action ] ;
	
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.securityPolicy.allowInvalidCertificates = YES;

	[manager POST:strUrl parameters:_params success:^(AFHTTPRequestOperation *operation, id _responseObject){
		
        if( _success )
        {
            _success( _responseObject ) ;
        }
		
    } failure:^(AFHTTPRequestOperation *operation, NSError *_error) {
        if( _failure )
        {
            NSLog(@"%@",_error.description);
            _failure( _error ) ;
            
        }
    }];
}

- ( void ) sendToService : ( NSDictionary* ) _params
				  action : ( NSString* ) _action
					data : ( NSData* ) _data
				 success : ( void (^)( id _responseObject ) ) _success
				 failure : ( void (^)( NSError* _error ) ) _failure
{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",WEBAPI_URL,_action ] ;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.securityPolicy.allowInvalidCertificates = YES;

	[manager POST:strUrl parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> _formData) {
        
        if( _data )
        {
			[ _formData appendPartWithFileData : _data
                                          name : @"photo"
                                      fileName : @"photo"
                                      mimeType : @"image/jpeg" ] ;
		}
        
    } success:^(AFHTTPRequestOperation *operation, id _responseObject) {
        
        if( _success )
        {
            _success( _responseObject ) ;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *_error) {
        
        if( _failure )
        {
            _failure( _error ) ;
        }
        
    }];
}

- ( void ) SignUp : ( NSString* ) _fbid
		firstname : ( NSString* ) _firstname
		 lastname : ( NSString* ) _lastname
		   gender : ( NSString* ) _gender
			  age : ( NSString* ) _age
		 latitude : ( NSString* ) _latitude
		longitude : ( NSString* ) _longitude
		   photo1 : ( NSString* ) _photo1
		   photo2 : ( NSString* ) _photo2
		   photo3 : ( NSString* ) _photo3
		   photo4 : ( NSString* ) _photo4
		   photo5 : ( NSString* ) _photo5
		   photo6 : ( NSString* ) _photo6
		   photo7 : ( NSString* ) _photo7
		   photo8 : ( NSString* ) _photo8
		   photo9 : ( NSString* ) _photo9
		  photo10 : ( NSString* ) _photo10
		successed : ( void (^)( id _responseObject ) ) _success
		  failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
    [ params setObject : _fbid				forKey : @"facebookid" ] ;
	[ params setObject : _firstname			forKey : @"firstname" ] ;
	[ params setObject : _lastname			forKey : @"lastname" ] ;
	[ params setObject : _gender			forKey : @"gender" ] ;
	[ params setObject : _latitude			forKey : @"latitude" ] ;
	[ params setObject : _longitude			forKey : @"longitude" ] ;
	[ params setObject : _age				forKey : @"age" ] ;
	[ params setObject : _photo1			forKey : @"photo1" ] ;
	[ params setObject : _photo2			forKey : @"photo2" ] ;
	[ params setObject : _photo3			forKey : @"photo3" ] ;
	[ params setObject : _photo4			forKey : @"photo4" ] ;
	[ params setObject : _photo5			forKey : @"photo5" ] ;
	[ params setObject : _photo6			forKey : @"photo6" ] ;
	[ params setObject : _photo7			forKey : @"photo7" ] ;
	[ params setObject : _photo8			forKey : @"photo8" ] ;
	[ params setObject : _photo9			forKey : @"photo9" ] ;
	[ params setObject : _photo10			forKey : @"photo10" ] ;
	
	[ self sendToService : params action : WEBAPI_SIGNUP success : _success failure : _failure ];
}

- ( void ) LoadUsers : ( NSString* ) _userfbid
			 success : ( void (^)( id _responseObject ) ) _success
			 failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userfbid			forKey : @"userfbid" ] ;
	
	[ self sendToService : params action : WEBAPI_USERS success : _success failure : _failure ];
}

- ( void ) LoadTrending : ( NSString* ) _userfbid
				success : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userfbid			forKey : @"userfbid" ] ;
	
	[ self sendToService : params action : WEBAPI_TRENDING success : _success failure : _failure ];
}

- ( void ) LoadUserProfile : ( NSString* ) _facebookid
				 successed : ( void (^)( id _responseObject ) ) _success
				   failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _facebookid			forKey : @"facebookid" ] ;
	
	[ self sendToService : params action : WEBAPI_LOADUSERPROFILE success : _success failure : _failure ];
}

- ( void ) RateUser : ( NSString* ) _useridfrom
		 userfbidto : ( NSString* ) _userfbidto
			  score : ( NSString* ) _score
			comment : ( NSString* ) _comment
		   nickname : ( NSString* ) _nickname
		  successed : ( void (^)( id _responseObject ) ) _success
			failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _useridfrom		forKey : @"useridfrom" ] ;
	[ params setObject : _userfbidto		forKey : @"userfbidto" ] ;
	[ params setObject : _score				forKey : @"score" ] ;
	[ params setObject : _comment			forKey : @"comment" ] ;
	[ params setObject : _nickname			forKey : @"nickname" ] ;

	[ self sendToService : params action : WEBAPI_RATEUSER success : _success failure : _failure ];
}

- ( void ) RateFBUser : ( NSString* ) _useridfrom
		   userfbidto : ( NSString* ) _userfbidto
				score : ( NSString* ) _score
			  comment : ( NSString* ) _comment
			 nickname : ( NSString* ) _nickname
			firstname : ( NSString* ) _firstname
			 lastname : ( NSString* ) _lastname
			   gender : ( NSString* ) _gender
				  age : ( NSString* ) _age
			 latitude : ( NSString* ) _latitude
			longitude : ( NSString* ) _longitude
			   photo1 : ( NSString* ) _photo1
			   photo2 : ( NSString* ) _photo2
			   photo3 : ( NSString* ) _photo3
			   photo4 : ( NSString* ) _photo4
			   photo5 : ( NSString* ) _photo5
			   photo6 : ( NSString* ) _photo6
			   photo7 : ( NSString* ) _photo7
			   photo8 : ( NSString* ) _photo8
			   photo9 : ( NSString* ) _photo9
			  photo10 : ( NSString* ) _photo10
			successed : ( void (^)( id _responseObject ) ) _success
			  failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _useridfrom		forKey : @"useridfrom" ] ;
	[ params setObject : _userfbidto		forKey : @"userfbidto" ] ;
	[ params setObject : _score				forKey : @"score" ] ;
	[ params setObject : _comment			forKey : @"comment" ] ;
	[ params setObject : _nickname			forKey : @"nickname" ] ;
	[ params setObject : _firstname			forKey : @"firstname" ] ;
	[ params setObject : _lastname			forKey : @"lastname" ] ;
	[ params setObject : _gender			forKey : @"gender" ] ;
	[ params setObject : _latitude			forKey : @"latitude" ] ;
	[ params setObject : _longitude			forKey : @"longitude" ] ;
	[ params setObject : _age				forKey : @"age" ] ;
	[ params setObject : _photo1			forKey : @"photo1" ] ;
	[ params setObject : _photo2			forKey : @"photo2" ] ;
	[ params setObject : _photo3			forKey : @"photo3" ] ;
	[ params setObject : _photo4			forKey : @"photo4" ] ;
	[ params setObject : _photo5			forKey : @"photo5" ] ;
	[ params setObject : _photo6			forKey : @"photo6" ] ;
	[ params setObject : _photo7			forKey : @"photo7" ] ;
	[ params setObject : _photo8			forKey : @"photo8" ] ;
	[ params setObject : _photo9			forKey : @"photo9" ] ;
	[ params setObject : _photo10			forKey : @"photo10" ] ;
	
	[ self sendToService : params action : WEBAPI_RATEFBUSER success : _success failure : _failure ];
}

- ( void ) Vote : ( NSString* ) _userid
		 rateid : ( NSString* ) _rateid
		   type : ( NSString* ) _type
	  successed : ( void (^)( id _responseObject ) ) _success
		failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _rateid		forKey : @"rateid" ] ;
	[ params setObject : _type			forKey : @"type" ] ;
	
	[ self sendToService : params action : WEBAPI_VOTE success : _success failure : _failure ];
}

- ( void ) Comment : ( NSString* ) _userid
			rateid : ( NSString* ) _rateid
		   comment : ( NSString* ) _comment
		 successed : ( void (^)( id _responseObject ) ) _success
		   failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _rateid		forKey : @"rateid" ] ;
	[ params setObject : _comment		forKey : @"comment" ] ;
	
	[ self sendToService : params action : WEBAPI_COMMENT success : _success failure : _failure ];
}

- ( void ) GetNotifications : ( NSString* ) _userid
				 facebookid : ( NSString* ) _facebookid
				  successed : ( void (^)( id _responseObject ) ) _success
					failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid			forKey : @"userid" ] ;
	[ params setObject : _facebookid		forKey : @"userfbid" ] ;
	
	[ self sendToService : params action : WEBAPI_GETNOTIFICATIONS success : _success failure : _failure ];
}

- ( void ) SendFeedback : ( NSString* ) _feedback
			  successed : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _feedback			forKey : @"feedback" ] ;
	
	[ self sendToService : params action : WEBAPI_SENDFEEDBACK success : _success failure : _failure ];
}

@end
