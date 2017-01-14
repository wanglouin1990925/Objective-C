//
//  YYYCommunication.h
//  CruiseShip
//
//  Created by Yang Dandan on 25/10/13.
//  Copyright (c) 2013 Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

//#define WEBAPI_URL              @"http://localhost/momo"
#define WEBAPI_URL				@"http://50.28.8.138/~admin/beehive"

@interface YYYCommunication : AFHTTPSessionManager<NSURLConnectionDelegate>
{
	NSMutableData *_responseData;
}

@property ( strong, nonatomic ) NSMutableDictionary		*dictInfo ;
@property ( strong, nonatomic ) NSMutableArray			*lstPhoto ;
@property ( strong, nonatomic ) NSMutableArray			*lstGroup ;
@property ( strong, nonatomic ) NSMutableArray			*lstFriend ;
@property ( strong, nonatomic ) NSMutableArray			*lstBlock ;

+ ( YYYCommunication* ) sharedManager ;
// Web Service ;76

- ( void ) sendToService : ( NSDictionary* ) _params
                  action : ( NSString* ) _action
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) sendToService : ( NSDictionary* ) _params
				  action : ( NSString* ) _action
					data : ( NSData* ) _data
				 success : ( void (^)( id _responseObject ) ) _success
				 failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) Login : ( NSString* ) _phone
        password : ( NSString* ) _password
        latitude : ( NSString* ) _latitude
       longitude : ( NSString* ) _longitude
       successed : ( void (^)( id _responseObject ) ) _success
         failure : ( void (^)( NSError* _error ) ) _failure;

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
		  failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) FBSignUp : ( NSString* ) _fbid
           username : ( NSString* ) _username
               name : ( NSString* ) _name
           birthday : ( NSString* ) _birthday
             gender : ( NSString* ) _gender
           latitude : ( NSString* ) _latitude
          longitude : ( NSString* ) _longitude
          successed : ( void (^)( id _responseObject ) ) _success
            failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) CreateGroup : ( NSString* ) _createrid
				  name : ( NSString* ) _name
				 about : ( NSString* ) _about
				 place : ( NSString* ) _place
			  latitude : ( NSString* ) _latitude
			 longitude : ( NSString* ) _longitude
				 photo : ( NSData* ) _photo
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) Forgot : ( NSString* ) _phone
		successed : ( void (^)( id _responseObject ) ) _success
		  failure : ( void (^)( NSError* _error ) ) _failure;

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
			   failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) EditGroupProfile : ( NSString* ) _userid
					groupid : ( NSString* ) _groupid
					  title : ( NSString* ) _title
					  place : ( NSString* ) _place
					  about : ( NSString* ) _about
				   latitude : ( NSString* ) _latitude
				  longitude : ( NSString* ) _longitude
				  successed : ( void (^)( id _responseObject ) ) _success
					failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) UploadGroupPhoto : ( NSString* ) _userid
					groupid : ( NSString* ) _groupid
					photoid : ( NSString* ) _photoid
					  photo : ( NSData* ) _photo
				  successed : ( void (^)( id _responseObject ) ) _success
					failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) EditGroupAvatar : ( NSString* ) _userid
				   groupid : ( NSString* ) _groupid
					 photo : ( NSData* ) _photo
				 successed : ( void (^)( id _responseObject ) ) _success
				   failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) ChangePassword : ( NSString* ) _userid
				 password : ( NSString* ) _password
				successed : ( void (^)( id _responseObject ) ) _success
				  failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) UploadPhoto : ( NSString* ) _userid
			   photoid : ( NSString* ) _photoid
				 photo : ( NSData* ) _photo
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) EditAvatar : ( NSString* ) _userid
				 type : ( NSString* ) _type
				photo : ( NSData* ) _photo
			successed : ( void (^)( id _responseObject ) ) _success
			  failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) LoadNearBy : ( NSString* ) _userid
			   offset : ( NSString* ) _offset
			 latitude : ( NSString* ) _latitude
			longitude : ( NSString* ) _longitude
			successed : ( void (^)( id _responseObject ) ) _success
			  failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) LoadGroups : ( NSString* ) _offset
			 latitude : ( NSString* ) _latitude
			longitude : ( NSString* ) _longitude
			successed : ( void (^)( id _responseObject ) ) _success
			  failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) LoadGroupProfile : ( NSString* ) _groupid
				  successed : ( void (^)( id _responseObject ) ) _success
					failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) LoadUserProfile : ( NSString* ) _userid
				 successed : ( void (^)( id _responseObject ) ) _success
				   failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) AddFriend : ( NSString* ) _userid
			useridto : ( NSString* ) _useridto
		   successed : ( void (^)( id _responseObject ) ) _success
			 failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) BlockFriend : ( NSString* ) _userid
			  useridto : ( NSString* ) _useridto
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) UnFriend : ( NSString* ) _userid
		   useridto : ( NSString* ) _useridto
		  successed : ( void (^)( id _responseObject ) ) _success
			failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) UnBlockFriend : ( NSString* ) _userid
				useridto : ( NSString* ) _useridto
			   successed : ( void (^)( id _responseObject ) ) _success
				 failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) LoadMyGroups : ( NSString* ) _userid
			  successed : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) JoinGroup : ( NSString* ) _userid
			 groupid : ( NSString* ) _groupid
		   successed : ( void (^)( id _responseObject ) ) _success
			 failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) LeaveGroup : ( NSString* ) _userid
			  groupid : ( NSString* ) _groupid
			successed : ( void (^)( id _responseObject ) ) _success
			  failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) DeleteGroup : ( NSString* ) _userid
               groupid : ( NSString* ) _groupid
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) AcceptGroup : ( NSString* ) _userid
			   groupid : ( NSString* ) _groupid
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) DeclineGroup : ( NSString* ) _userid
				groupid : ( NSString* ) _groupid
			  successed : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) GetPassword : ( NSString* ) _phone
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure;

//Chat Feature

- ( void ) LoadMessageHistory : ( NSString* ) _userid
					 useridto : ( NSString* ) _useridto
					successed : ( void (^)( id _responseObject ) ) _success
					  failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) SendMessage : ( NSString* ) _userid
			  useridto : ( NSString* ) _useridto
			   message : ( NSString* ) _message
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) SendFile : ( NSString* ) _userid
		   useridto : ( NSString* ) _useridto
			   type : ( NSString* ) _type
			   file : ( NSData*) _file
		  successed : ( void (^)( id _responseObject ) ) _success
			failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) IncomeMessage : ( NSString* ) _userid
			   successed : ( void (^)( id _responseObject ) ) _success
				 failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) ReadMessage : ( NSString* ) _userid
			  useridto : ( NSString* ) _useridto
			 successed : ( void (^)( id _responseObject ) ) _success
			   failure : ( void (^)( NSError* _error ) ) _failure;

// Group Chat

- ( void ) LoadGMessageHistory : ( NSString* ) _userid
					   groupid : ( NSString* ) _groupid
					 successed : ( void (^)( id _responseObject ) ) _success
					   failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) SendGMessage : ( NSString* ) _userid
				groupid : ( NSString* ) _groupid
			 groupusers : ( NSString* ) _groupusers
				message : ( NSString* ) _message
			  successed : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) SendGFile : ( NSString* ) _userid
			 groupid : ( NSString* ) _groupid
		  groupusers : ( NSString* ) _groupusers
				type : ( NSString* ) _type
				file : ( NSData* ) _file
		   successed : ( void (^)( id _responseObject ) ) _success
			 failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) ReadGMessage : ( NSString* ) _userid
				groupid : ( NSString* ) _groupid
			  successed : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) DeleteChatsHistory : ( NSString* ) _lstmsgid
					glstmsgid : ( NSString* ) _glstmsgid
					successed : ( void (^)( id _responseObject ) ) _success
					  failure : ( void (^)( NSError* _error ) ) _failure;

@end
