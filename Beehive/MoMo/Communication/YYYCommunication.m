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

#define WEBAPI_LOGIN				@"/signin.php"
#define WEBAPI_SIGNUP				@"/signup.php"
#define WEBAPI_FBSIGNUP				@"/signupfb.php"
#define WEBAPI_FORGOT				@"/forgot.php"
#define WEBAPI_UPLOADPHOTO			@"/uploadphoto.php"
#define WEBAPI_EDITPROFILE			@"/editprofile.php"
#define WEBAPI_CHANGEPASS			@"/changepass.php"
#define WEBAPI_AVATAR				@"/editavatar.php"
#define WEBAPI_LOADNEARBY			@"/loadnearby.php"
#define WEBAPI_LOADUSERPROFILE		@"/loaduserprofile.php"
#define WEBAPI_CREATEGROUP			@"/creategroup.php"
#define WEBAPI_LOADGROUP			@"/loadgroups.php"
#define WEBAPI_LOADGROUPPROFILE		@"/loadgroupprofile.php"
#define WEBAPI_LOADMESSAGEHISTORY	@"/getallmessage.php"
#define WEBAPI_SENDMESSAGE			@"/sendmessage.php"
#define WEBAPI_INCOMEMESSAGE		@"/getincoming.php"
#define WEBAPI_READMESSAGE			@"/readmessage.php"
#define WEBAPI_SENDFILE				@"/sendfile.php"
#define WEBAPI_ADDFRIEND			@"/addfriend.php"
#define WEBAPI_BLOCKFRIEND			@"/blockfriend.php"
#define WEBAPI_UNFRIEND				@"/unfriend.php"
#define WEBAPI_UNBLOCKFRIEND		@"/unblock.php"
#define WEBAPI_EDITGROUPPROFILE		@"/editgroupprofile.php"
#define WEBAPI_EDITGROUPAVATAR		@"/editgroupavatar.php"
#define WEBAPI_UPLOADGROUPPHOTO		@"/uploadgphoto.php"
#define WEBAPI_JOINGROUP			@"/joingroup.php"
#define WEBAPI_LEAVEGROUP			@"/leavegroup.php"
#define WEBAPI_DECLINEGROUP			@"/declinegroup.php"
#define WEBAPI_ACCEPTGROUP			@"/acceptgroup.php"
#define WEBAPI_LOADGMESSAGEHISTORY	@"/getallgmessage.php"
#define WEBAPI_SENDGMESSAGE			@"/sendgmessage.php"
#define WEBAPI_SENDGFILE			@"/sendgfile.php"
#define WEBAPI_READGMESSAGE			@"/readgmessage.php"
#define WEBAPI_DELETECHATHISTORY	@"/deletechathistory.php"
#define WEBAPI_LOADMYGROUPS			@"/loadmygroups.php"
#define WEBAPI_GETPASSWORD          @"/getpassword.php"
#define WEBAPI_DELETEGROUP          @"/deletegroup.php"

@implementation YYYCommunication

@synthesize dictInfo;
@synthesize lstGroup;
@synthesize lstPhoto;
@synthesize lstBlock;
@synthesize lstFriend;

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
        [ self setDictInfo : nil ] ;
		[ self setLstGroup : nil ];
		[ self setLstPhoto : nil ];
		[ self setLstBlock : nil ];
		[ self setLstFriend : nil ];
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
//	manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
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
//	manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
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

- ( void ) sendToService : ( NSDictionary* ) _params
				  action : ( NSString* ) _action
					file : ( NSData* ) _file
					type : ( NSString* ) _type
				 success : ( void (^)( id _responseObject ) ) _success
				 failure : ( void (^)( NSError* _error ) ) _failure
{
	
	NSString *strUrl = [NSString stringWithFormat:@"%@%@",WEBAPI_URL,_action ] ;
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	manager.securityPolicy.allowInvalidCertificates = YES;
	
	[manager POST:strUrl parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> _formData) {
		
		if( _file )
		{
			NSString *mimeType = @"";
			if ([_type isEqualToString:@"photo"])
				mimeType = @"image/jpeg";
			
			else if ([_type isEqualToString:@"video"])
				mimeType = @"video/quicktime";
			
			else if ([_type isEqualToString:@"voice"])
				mimeType = @"audio/aac";
			
			[ _formData appendPartWithFileData : _file
										  name : @"file"
									  fileName : @"file"
									  mimeType : mimeType ] ;
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

- ( void ) Login : ( NSString* ) _phone
        password : ( NSString* ) _password
        latitude : ( NSString* ) _latitude
       longitude : ( NSString* ) _longitude
       successed : ( void (^)( id _responseObject ) ) _success
         failure : ( void (^)( NSError* _error ) ) _failure
{
    NSString *_encrypt = [[YYYAppDelegate sharedDelegate] encryptPassword:_password];
    
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : _phone				forKey : @"phone" ] ;
    [ params setObject : _encrypt			forKey : @"password" ] ;
    [ params setObject : _latitude			forKey : @"latitude" ] ;
    [ params setObject : _longitude         forKey : @"longitude" ] ;
    
    [ self sendToService : params action : WEBAPI_LOGIN success : _success failure : _failure ];
}

- ( void ) SignUp : ( NSString* ) _phone
		 password : ( NSString* ) _password
		 username : ( NSString* ) _username
			 name : ( NSString* ) _name
		 birthday : ( NSString* ) _birthday
		   gender : ( NSString* ) _gender
		 latitude : ( NSString* ) _latitude
		longitude : ( NSString* ) _longitude
			photo : ( NSData* ) _photo
		successed : ( void (^)( id _responseObject ) ) _success
		  failure : ( void (^)( NSError* _error ) ) _failure
{
    NSString *_encrypt = [[YYYAppDelegate sharedDelegate] encryptPassword:_password];
    
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
    [ params setObject : _phone				forKey : @"phone" ] ;
	[ params setObject : _encrypt			forKey : @"password" ] ;
	[ params setObject : _username			forKey : @"username" ] ;
	[ params setObject : _name				forKey : @"name" ] ;
	[ params setObject : _birthday			forKey : @"birthday" ] ;
	[ params setObject : _gender			forKey : @"gender" ] ;
	[ params setObject : _latitude			forKey : @"latitude" ] ;
	[ params setObject : _longitude			forKey : @"longitude" ] ;
	
	[ self sendToService : params action : WEBAPI_SIGNUP data:_photo success : _success failure : _failure ];
}

- ( void ) FBSignUp : ( NSString* ) _fbid
           username : ( NSString* ) _username
               name : ( NSString* ) _name
           birthday : ( NSString* ) _birthday
             gender : ( NSString* ) _gender
           latitude : ( NSString* ) _latitude
          longitude : ( NSString* ) _longitude
          successed : ( void (^)( id _responseObject ) ) _success
            failure : ( void (^)( NSError* _error ) ) _failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : @""				forKey : @"phone" ] ;
    [ params setObject : @""                forKey : @"password" ] ;
    [ params setObject : _username			forKey : @"username" ] ;
    [ params setObject : _name				forKey : @"name" ] ;
    [ params setObject : _birthday			forKey : @"birthday" ] ;
    [ params setObject : _gender			forKey : @"gender" ] ;
    [ params setObject : _latitude			forKey : @"latitude" ] ;
    [ params setObject : _longitude			forKey : @"longitude" ] ;
    [ params setObject : _fbid              forKey : @"fbid" ] ;
    
    [ self sendToService : params action : WEBAPI_FBSIGNUP success : _success failure : _failure ];
}

- ( void ) Forgot : ( NSString* ) _phone
		successed : ( void (^)( id _responseObject ) ) _success
		  failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
    [ params setObject : _phone				forKey : @"phone" ] ;
	
	[ self sendToService : params action : WEBAPI_FORGOT success : _success failure : _failure ];
}

- ( void ) UploadPhoto : ( NSString* ) _userid
			   photoid : ( NSString* ) _photoid
				 photo : ( NSData* ) _photo
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
    [ params setObject : _userid				forKey : @"userid" ] ;
	[ params setObject : _photoid				forKey : @"photoid" ] ;
	
	[ self sendToService : params action : WEBAPI_UPLOADPHOTO data:_photo success : _success failure : _failure ];
}

- ( void ) EditProfile : ( NSString* ) _userid
              username : ( NSString* ) _username
                  name : ( NSString* ) _name
                gender : ( NSString* ) _gender
              birthday : ( NSString* ) _birthday
                 about : ( NSString* ) _about
               company : ( NSString* ) _company
            university : ( NSString* ) _university
              hometown : ( NSString* ) _hometown
               hobbies : ( NSString* ) _hobbies
                 music : ( NSString* ) _music
                 books : ( NSString* ) _books
                movies : ( NSString* ) _movies
               looking : ( NSString* ) _looking
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
    [ params setObject : _username			forKey : @"username" ] ;
	[ params setObject : _name				forKey : @"name" ] ;
	[ params setObject : _gender			forKey : @"gender" ] ;
	[ params setObject : _birthday			forKey : @"birthday" ] ;
	[ params setObject : _about				forKey : @"about" ] ;
	[ params setObject : _userid			forKey : @"userid" ] ;
	[ params setObject : _company			forKey : @"company" ] ;
    [ params setObject : _university		forKey : @"university" ] ;
    [ params setObject : _hometown			forKey : @"hometown" ] ;
    [ params setObject : _hobbies			forKey : @"hobbies" ] ;
    [ params setObject : _music             forKey : @"music" ] ;
    [ params setObject : _books             forKey : @"books" ] ;
    [ params setObject : _movies			forKey : @"movies" ] ;
    [ params setObject : _looking			forKey : @"looking" ] ;
    
	[ self sendToService : params action : WEBAPI_EDITPROFILE success : _success failure : _failure ];
}

- ( void ) ChangePassword : ( NSString* ) _userid
				 password : ( NSString* ) _password
				successed : ( void (^)( id _responseObject ) ) _success
				  failure : ( void (^)( NSError* _error ) ) _failure
{
    NSString *_encrypt = [[YYYAppDelegate sharedDelegate] encryptPassword:_password];
    
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
    [ params setObject : _encrypt			forKey : @"password" ] ;
	[ params setObject : _userid			forKey : @"userid" ] ;
	
	[ self sendToService : params action : WEBAPI_CHANGEPASS success : _success failure : _failure ];
}

- ( void ) EditAvatar : ( NSString* ) _userid
				 type : ( NSString* ) _type
				photo : ( NSData* ) _photo
			successed : ( void (^)( id _responseObject ) ) _success
			  failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
    [ params setObject : _userid			forKey : @"userid" ] ;
	[ params setObject : _type				forKey : @"type" ] ;
	
	[ self sendToService : params action : WEBAPI_AVATAR data:_photo success : _success failure : _failure ];
}

- ( void ) LoadNearBy : ( NSString* ) _userid
			   offset : ( NSString* ) _offset
			 latitude : ( NSString* ) _latitude
			longitude : ( NSString* ) _longitude
			successed : ( void (^)( id _responseObject ) ) _success
			  failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
    [ params setObject : _userid			forKey : @"userid" ] ;
	[ params setObject : _offset			forKey : @"offset" ] ;
	[ params setObject : _latitude			forKey : @"latitude" ] ;
	[ params setObject : _longitude			forKey : @"longitude" ] ;
	
	[ self sendToService : params action : WEBAPI_LOADNEARBY success : _success failure : _failure ];
}

- ( void ) LoadUserProfile : ( NSString* ) _userid
				 successed : ( void (^)( id _responseObject ) ) _success
				   failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
    [ params setObject : _userid			forKey : @"userid" ] ;
	
	[ self sendToService : params action : WEBAPI_LOADUSERPROFILE success : _success failure : _failure ];
}

- ( void ) CreateGroup : ( NSString* ) _createrid
				  name : ( NSString* ) _name
				 about : ( NSString* ) _about
				 place : ( NSString* ) _place
			  latitude : ( NSString* ) _latitude
			 longitude : ( NSString* ) _longitude
				 photo : ( NSData* ) _photo
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
    [ params setObject : _createrid		forKey : @"userid" ] ;
	[ params setObject : _name			forKey : @"name" ] ;
	[ params setObject : _place			forKey : @"place" ] ;
	[ params setObject : _about			forKey : @"about" ] ;
	[ params setObject : _latitude		forKey : @"latitude" ] ;
	[ params setObject : _longitude		forKey : @"longitude" ] ;
	
	[ self sendToService : params action : WEBAPI_CREATEGROUP data:_photo success : _success failure : _failure ];
}

- ( void ) EditGroupProfile : ( NSString* ) _userid
					groupid : ( NSString* ) _groupid
					  title : ( NSString* ) _title
					  place : ( NSString* ) _place
					  about : ( NSString* ) _about
				   latitude : ( NSString* ) _latitude
				  longitude : ( NSString* ) _longitude
				  successed : ( void (^)( id _responseObject ) ) _success
					failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _groupid		forKey : @"groupid" ] ;
	[ params setObject : _title			forKey : @"title" ] ;
	[ params setObject : _about			forKey : @"about" ] ;
	[ params setObject : _place			forKey : @"place" ] ;
	[ params setObject : _latitude		forKey : @"latitude" ] ;
	[ params setObject : _longitude		forKey : @"longitude" ] ;
	
	[ self sendToService : params action : WEBAPI_EDITGROUPPROFILE success : _success failure : _failure ];
}

- ( void ) EditGroupAvatar : ( NSString* ) _userid
				   groupid : ( NSString* ) _groupid
					 photo : ( NSData* ) _photo
				 successed : ( void (^)( id _responseObject ) ) _success
				   failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid			forKey : @"userid" ] ;
	[ params setObject : _groupid			forKey : @"groupid" ] ;
	
	[ self sendToService : params action : WEBAPI_EDITGROUPAVATAR data:_photo success : _success failure : _failure ];
}

- ( void ) UploadGroupPhoto : ( NSString* ) _userid
					groupid : ( NSString* ) _groupid
					photoid : ( NSString* ) _photoid
					  photo : ( NSData* ) _photo
				  successed : ( void (^)( id _responseObject ) ) _success
					failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid				forKey : @"userid" ] ;
	[ params setObject : _groupid				forKey : @"groupid" ] ;
	[ params setObject : _photoid				forKey : @"photoid" ] ;
	
	[ self sendToService : params action : WEBAPI_UPLOADGROUPPHOTO data:_photo success : _success failure : _failure ];
}

- ( void ) LoadGroups : ( NSString* ) _offset
			 latitude : ( NSString* ) _latitude
			longitude : ( NSString* ) _longitude
			successed : ( void (^)( id _responseObject ) ) _success
			  failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _offset		forKey : @"offset" ] ;
	[ params setObject : _latitude		forKey : @"latitude" ] ;
	[ params setObject : _longitude		forKey : @"longitude" ] ;
	
	[ self sendToService : params action : WEBAPI_LOADGROUP success : _success failure : _failure ];
}

- ( void ) LoadGroupProfile : ( NSString* ) _groupid
				  successed : ( void (^)( id _responseObject ) ) _success
					failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _groupid		forKey : @"groupid" ] ;
	
	[ self sendToService : params action : WEBAPI_LOADGROUPPROFILE success : _success failure : _failure ];
}

- ( void ) LoadMyGroups : ( NSString* ) _userid
			  successed : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	
	[ self sendToService : params action : WEBAPI_LOADMYGROUPS success : _success failure : _failure ];
}

- ( void ) JoinGroup : ( NSString* ) _userid
			 groupid : ( NSString* ) _groupid
		   successed : ( void (^)( id _responseObject ) ) _success
			 failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _groupid		forKey : @"groupid" ] ;
	
	[ self sendToService : params action : WEBAPI_JOINGROUP success : _success failure : _failure ];
}

- ( void ) LeaveGroup : ( NSString* ) _userid
			  groupid : ( NSString* ) _groupid
			successed : ( void (^)( id _responseObject ) ) _success
			  failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _groupid		forKey : @"groupid" ] ;
	
	[ self sendToService : params action : WEBAPI_LEAVEGROUP success : _success failure : _failure ];
}

- ( void ) DeleteGroup : ( NSString* ) _userid
               groupid : ( NSString* ) _groupid
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : _userid		forKey : @"userid" ] ;
    [ params setObject : _groupid		forKey : @"groupid" ] ;
    
    [ self sendToService : params action : WEBAPI_DELETEGROUP success : _success failure : _failure ];
}

- ( void ) AcceptGroup : ( NSString* ) _userid
			   groupid : ( NSString* ) _groupid
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _groupid		forKey : @"groupid" ] ;
	
	[ self sendToService : params action : WEBAPI_ACCEPTGROUP success : _success failure : _failure ];
}

- ( void ) DeclineGroup : ( NSString* ) _userid
				groupid : ( NSString* ) _groupid
			  successed : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _groupid		forKey : @"groupid" ] ;
	
	[ self sendToService : params action : WEBAPI_DECLINEGROUP success : _success failure : _failure ];
}

- ( void ) LoadMessageHistory : ( NSString* ) _userid
					 useridto : ( NSString* ) _useridto
					successed : ( void (^)( id _responseObject ) ) _success
					  failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _useridto		forKey : @"useridto" ] ;
	
	[ self sendToService : params action : WEBAPI_LOADMESSAGEHISTORY success : _success failure : _failure ];
}

- ( void ) SendMessage : ( NSString* ) _userid
			  useridto : ( NSString* ) _useridto
			   message : ( NSString* ) _message
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"useridfrom" ] ;
	[ params setObject : _useridto		forKey : @"useridto" ] ;
	[ params setObject : _message		forKey : @"message" ] ;
	
	[ self sendToService : params action : WEBAPI_SENDMESSAGE success : _success failure : _failure ];
}

- ( void ) SendFile : ( NSString* ) _userid
		   useridto : ( NSString* ) _useridto
			   type : ( NSString* ) _type
			   file : ( NSData*) _file
		  successed : ( void (^)( id _responseObject ) ) _success
			failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid				forKey : @"useridfrom" ] ;
	[ params setObject : _useridto				forKey : @"useridto" ] ;
	[ params setObject : _type					forKey : @"type" ] ;
	
	[ self sendToService : params action : WEBAPI_SENDFILE file : _file type : _type success : _success failure : _failure ];
}

- ( void ) IncomeMessage : ( NSString* ) _userid
			   successed : ( void (^)( id _responseObject ) ) _success
				 failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	
	[ self sendToService : params action : WEBAPI_INCOMEMESSAGE success : _success failure : _failure ];
}

- ( void ) ReadMessage : ( NSString* ) _userid
			  useridto : ( NSString* ) _useridto
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _useridto		forKey : @"useridto" ] ;
	
	[ self sendToService : params action : WEBAPI_READMESSAGE success : _success failure : _failure ];
}

- ( void ) AddFriend : ( NSString* ) _userid
			useridto : ( NSString* ) _useridto
		   successed : ( void (^)( id _responseObject ) ) _success
			 failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _useridto		forKey : @"useridto" ] ;
	
	[ self sendToService : params action : WEBAPI_ADDFRIEND success : _success failure : _failure ];
}

- ( void ) BlockFriend : ( NSString* ) _userid
			  useridto : ( NSString* ) _useridto
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _useridto		forKey : @"useridto" ] ;
	
	[ self sendToService : params action : WEBAPI_BLOCKFRIEND success : _success failure : _failure ];
}

- ( void ) UnFriend : ( NSString* ) _userid
		   useridto : ( NSString* ) _useridto
		  successed : ( void (^)( id _responseObject ) ) _success
			failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _useridto		forKey : @"useridto" ] ;
	
	[ self sendToService : params action : WEBAPI_UNFRIEND success : _success failure : _failure ];
}

- ( void ) UnBlockFriend : ( NSString* ) _userid
				useridto : ( NSString* ) _useridto
			   successed : ( void (^)( id _responseObject ) ) _success
				 failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid		forKey : @"userid" ] ;
	[ params setObject : _useridto		forKey : @"useridto" ] ;
	
	[ self sendToService : params action : WEBAPI_UNBLOCKFRIEND success : _success failure : _failure ];
}

- ( void ) LoadGMessageHistory : ( NSString* ) _userid
					   groupid : ( NSString* ) _groupid
					 successed : ( void (^)( id _responseObject ) ) _success
					   failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid				forKey : @"userid" ] ;
	[ params setObject : _groupid				forKey : @"groupid" ] ;
	
	[ self sendToService : params action : WEBAPI_LOADGMESSAGEHISTORY success : _success failure : _failure ];
}

- ( void ) SendGMessage : ( NSString* ) _userid
				groupid : ( NSString* ) _groupid
			 groupusers : ( NSString* ) _groupusers
				message : ( NSString* ) _message
			  successed : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid				forKey : @"useridfrom" ] ;
	[ params setObject : _groupid				forKey : @"groupid" ] ;
	[ params setObject : _groupusers			forKey : @"groupusers" ] ;
	[ params setObject : _message				forKey : @"message" ] ;
	
	[ self sendToService : params action : WEBAPI_SENDGMESSAGE success : _success failure : _failure ];
}

- ( void ) SendGFile : ( NSString* ) _userid
			 groupid : ( NSString* ) _groupid
		  groupusers : ( NSString* ) _groupusers
				type : ( NSString* ) _type
				file : ( NSData* ) _file
		   successed : ( void (^)( id _responseObject ) ) _success
			 failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid				forKey : @"useridfrom" ] ;
	[ params setObject : _groupid				forKey : @"groupid" ] ;
	[ params setObject : _groupusers			forKey : @"groupusers" ] ;
	[ params setObject : _type					forKey : @"type" ] ;
	
	[ self sendToService : params action : WEBAPI_SENDGFILE file : _file type : _type success : _success failure : _failure ];
}

- ( void ) ReadGMessage : ( NSString* ) _userid
				groupid : ( NSString* ) _groupid
			  successed : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _userid				forKey : @"userid" ] ;
	[ params setObject : _groupid				forKey : @"groupid" ] ;
	
	[ self sendToService : params action : WEBAPI_READGMESSAGE success : _success failure : _failure ];
}

- ( void ) DeleteChatsHistory : ( NSString* ) _lstmsgid
					glstmsgid : ( NSString* ) _glstmsgid
					successed : ( void (^)( id _responseObject ) ) _success
					  failure : ( void (^)( NSError* _error ) ) _failure
{
	NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
	
	[ params setObject : _lstmsgid				forKey : @"lstmsgid" ] ;
	[ params setObject : _glstmsgid				forKey : @"glstmsgid" ] ;
	
	[ self sendToService : params action : WEBAPI_DELETECHATHISTORY success : _success failure : _failure ];
}

- ( void ) GetPassword : ( NSString* ) _phone
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure
{
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    
    [ params setObject : _phone				forKey : @"phone" ] ;
    
    [ self sendToService : params action : WEBAPI_GETPASSWORD success : _success failure : _failure ];
}

@end
