//
//  YYYCommunication.h
//  CruiseShip
//
//  Created by Yang Dandan on 25/10/13.
//  Copyright (c) 2013 Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

#define WEBAPI_URL               @"http://localhost/dnd"
//#define WEBAPI_URL				@"http://karanpaulmultani.com/DND"

@interface YYYCommunication : AFHTTPSessionManager<NSURLConnectionDelegate>
{
	NSMutableData *_responseData;
}

@property ( strong, nonatomic ) NSMutableDictionary		*me ;
@property ( strong, nonatomic ) NSMutableArray			*lstNotification ;

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
		  failure : ( void (^)( NSError* _error ) ) _failure;

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
			  failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) LoadUsers : ( NSString* ) _userfbid
			 success : ( void (^)( id _responseObject ) ) _success
			 failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) LoadTrending : ( NSString* ) _userfbid
				success : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) LoadUserProfile : ( NSString* ) _facebookid
				 successed : ( void (^)( id _responseObject ) ) _success
				   failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) RateUser : ( NSString* ) _useridfrom
		 userfbidto : ( NSString* ) _userfbidto
			  score : ( NSString* ) _score
			comment : ( NSString* ) _comment
		   nickname : ( NSString* ) _nickname
		  successed : ( void (^)( id _responseObject ) ) _success
			failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) Vote : ( NSString* ) _userid
		 rateid : ( NSString* ) _rateid
		   type : ( NSString* ) _type
	  successed : ( void (^)( id _responseObject ) ) _success
		failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) Comment : ( NSString* ) _userid
			rateid : ( NSString* ) _rateid
		   comment : ( NSString* ) _comment
		 successed : ( void (^)( id _responseObject ) ) _success
		   failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) SendFeedback : ( NSString* ) _feedback
			  successed : ( void (^)( id _responseObject ) ) _success
				failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) GetNotifications : ( NSString* ) _userid
				 facebookid : ( NSString* ) _facebookid
				  successed : ( void (^)( id _responseObject ) ) _success
					failure : ( void (^)( NSError* _error ) ) _failure;

@end
