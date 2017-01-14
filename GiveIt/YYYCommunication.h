//
//  YYYCommunication.h
//  CruiseShip
//
//  Created by Yang Dandan on 25/10/13.
//  Copyright (c) 2013 Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define WEBAPI_URL               @"http://localhost/giveit/"
//#define WEBAPI_URL               @"http://lasshop.se/old/yang/giveit/"
#define WEBAPI_URL               @"http://30days2go.com/"

@interface YYYCommunication : NSObject

@property ( strong, nonatomic ) NSDictionary*         me ;

+ ( YYYCommunication* ) sharedManager ;
// Web Service ;
- ( void ) sendToService : ( NSDictionary* ) _params
                  action : ( NSString* ) _action
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) sendToService : ( NSDictionary* ) _params
                  action : ( NSString* ) _action
                   photo : ( NSData* ) _photo
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure ;

- ( void ) signup : ( NSString* ) _username
         password : ( NSString* ) _password
            email : ( NSString* ) _email
            photo : ( NSData* ) _photo
        successed : ( void (^)( id _responseObject ) ) _success
          failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) login : ( NSString* ) _username
        password : ( NSString* ) _password
       successed : ( void (^)( id _responseObject ) ) _success
         failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) getprofile : ( NSString* ) _userid
                   me : ( NSString* ) _me
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) addpost : ( NSString* ) _projectid
         daynumber : ( NSString* ) _daynumber
              date : ( NSString* ) _date
             video : ( NSData* ) _video
             photo : ( NSData* ) _photo
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) like : ( NSString* ) _userid
         postid : ( NSString* ) _postid
         action : ( NSString* ) _action
      successed : ( void (^)( id _responseObject ) ) _success
        failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) getcomment : ( NSString* ) _postid
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure;


- ( void ) addcomment : ( NSString* ) _postid
               userid : ( NSString* ) _userid
              comment : ( NSString* ) _comment
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) loadproject : ( NSString* ) _userid
              category : ( NSString* ) _category
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) editprofile : ( NSString* ) _userid
                 query : ( NSString* ) _query
                 pdata : ( NSData* ) _pdata
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) getmyproject : ( NSString* ) _userid
              successed : ( void (^)( id _responseObject ) ) _success
                failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) updateproject : ( NSString* ) _projectid
                   query : ( NSString* ) _query
               successed : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) deleteproject : ( NSString* ) _projectid
               successed : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) follow : ( NSString* ) _useridfrom
         useridto : ( NSString* ) _useridto
           action : ( NSString* ) _action
        successed : ( void (^)( id _responseObject ) ) _success
          failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) addproject : ( NSString* ) _userid
                title : ( NSString* ) _title
             category : ( NSString* ) _category
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) getnotifications : ( NSString* ) _userid
                  successed : ( void (^)( id _responseObject ) ) _success
                    failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) getpost : ( NSString* ) _userid
            postid : ( NSString* ) _postid
         successed : ( void (^)( id _responseObject ) ) _success
           failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) getpassword : ( NSString* ) _email
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) report : ( NSString* ) _content
        successed : ( void (^)( id _responseObject ) ) _success
          failure : ( void (^)( NSError* _error ) ) _failure;

- ( void ) deletepost : ( NSString* ) _postid
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure;

@end

