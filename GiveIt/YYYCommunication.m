//
//  YYYCommunication.m
//  CruiseShip
//
//  Created by Yang Dandan on 25/10/13.
//  Copyright (c) 2013 Yang. All rights reserved.
//

#import "YYYCommunication.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import <AVFoundation/AVFoundation.h>

// Sign ;
#define WEBAPI_SIGNUP                   @"signup.php"
#define WEBAPI_LOGIN                    @"signin.php"
#define WEBAPI_GETPROFILE               @"getprofile.php"
#define WEBAPI_ADDPOST                  @"addpost.php"
#define WEBAPI_LIKE                     @"like.php"
#define WEBAPI_GETCOMMENT               @"getcomment.php"
#define WEBAPI_ADDCOMMENT               @"addcomment.php"
#define WEBAPI_LOADPROJECT              @"getproject.php"
#define WEBAPI_EDITPROFILE              @"editprofile.php"
#define WEBAPI_GETMYPROJECT             @"getmyproject.php"
#define WEBAPI_UPDATEPROJECT            @"updateproject.php"
#define WEBAPI_DELETEPROJECT            @"deleteproject.php"
#define WEBAPI_FOLLOW                   @"follow.php"
#define WEBAPI_ADDPROJECT               @"addproject.php"
#define WEBAPI_GETNOTIFICATION          @"getnotification.php"
#define WEBAPI_GETPOST                  @"getpost.php"
#define WEBAPI_GETPASSWORD              @"getpassword.php"
#define WEBAPI_REPORT                   @"report.php"
#define WEBAPI_DELETPOST                @"deletepost.php"

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
    }
    
    return self ;
}

#pragma mark - Web Service
- ( void ) sendToService : ( NSDictionary* ) _params
                  action : ( NSString* ) _action
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure
{
    NSURL*                  url         = [ NSURL URLWithString : [NSString stringWithFormat:@"%@%@",WEBAPI_URL,_action ] ] ;
    AFHTTPClient*           client      = [ [ AFHTTPClient alloc ] initWithBaseURL: url ] ;
    
    NSMutableURLRequest*    request     = [ client requestWithMethod : @"POST" path : nil parameters : _params ] ;
    AFHTTPRequestOperation* operation   = [ [ AFHTTPRequestOperation alloc ] initWithRequest : request ] ;
    
    [ client registerHTTPOperationClass : [ AFHTTPRequestOperation class ] ] ;
    [ operation setCompletionBlockWithSuccess : ^( AFHTTPRequestOperation* _operation, id _responseObject ) {
        
        //        NSString* string = [ [ NSString alloc ] initWithData : _responseObject encoding : NSUTF8StringEncoding ] ;
        //         NSLog( @"%@", string ) ;
        
        // Response Object ;
        id responseObject   = [ NSJSONSerialization JSONObjectWithData : _responseObject
                                                               options : kNilOptions
                                                                 error : nil ] ;
        // Success ;
        if( _success )
        {
            _success( responseObject ) ;
        }
        
    } failure : ^( AFHTTPRequestOperation* _operation, NSError* _error )
     {
         NSLog( @"%@", _error.description ) ;
         
         // Failture ;
         if( _failure )
         {
             _failure( _error ) ;
         }
         
     } ] ;
    [ operation start ] ;
}

- ( void ) sendToService : ( NSDictionary* ) _params
                  action : ( NSString* ) _action
                   photo : ( NSData* ) _photo
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure
{
    
    NSURL*                  url         = [ NSURL URLWithString : [NSString stringWithFormat:@"%@%@",WEBAPI_URL,_action ] ] ;
    AFHTTPClient*           client      = [ [ AFHTTPClient alloc ] initWithBaseURL : url ] ;
    NSMutableURLRequest*    request     = [ client multipartFormRequestWithMethod : @"POST"
                                                                             path : nil
                                                                       parameters : _params
                                                        constructingBodyWithBlock : ^( id <AFMultipartFormData > _formData ) {
                                                            if( _photo )
                                                            {
                                                                [ _formData appendPartWithFileData : _photo
                                                                                              name : @"photo"
                                                                                          fileName : @"photo"
                                                                                          mimeType : @"image/jpeg" ] ;
                                                            }
                                                        } ] ;
    
    AFHTTPRequestOperation* operation   = [ [ AFHTTPRequestOperation alloc ] initWithRequest : request ] ;
    
    [ client registerHTTPOperationClass : [ AFHTTPRequestOperation class ] ] ;
    [ operation setCompletionBlockWithSuccess : ^( AFHTTPRequestOperation* _operation, id _responseObject ) {
        NSString* string = [ [ NSString alloc ] initWithData : _responseObject encoding : NSUTF8StringEncoding ] ;
		NSLog( @"%@", string ) ;
        
        // Response Object ;
        id responseObject   = [ NSJSONSerialization JSONObjectWithData : _responseObject
                                                               options : kNilOptions
                                                                 error : nil ] ;
        
        // Success ;
        if( _success )
        {
            _success( responseObject ) ;
        }
        
    } failure : ^( AFHTTPRequestOperation* _operation, NSError* _error ) {
        
        NSLog( @"%@", _error.description ) ;
        
        // Failture ;
        if( _failure )
        {
            _failure( _error ) ;
        }
    } ] ;
    
    [ operation start ] ;
}

- ( void ) sendToService : ( NSDictionary* ) _params
                  action : ( NSString* ) _action
                   photo : ( NSData* ) _photo
                   video : ( NSData* ) _video
                 success : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure
{
    
    NSURL*                  url         = [ NSURL URLWithString : [NSString stringWithFormat:@"%@%@",WEBAPI_URL,_action ] ] ;
    AFHTTPClient*           client      = [ [ AFHTTPClient alloc ] initWithBaseURL : url ] ;
    NSMutableURLRequest*    request     = [ client multipartFormRequestWithMethod : @"POST"
                                                                             path : nil
                                                                       parameters : _params
                                                        constructingBodyWithBlock : ^( id <AFMultipartFormData > _formData ) {
                                                            if( _photo )
                                                            {
                                                                [ _formData appendPartWithFileData : _photo
                                                                                              name : @"photo"
                                                                                          fileName : @"photo"
                                                                                          mimeType : @"image/jpeg" ] ;
                                                                
                                                                [ _formData appendPartWithFileData :
                                                                 _video name:@"video" fileName:@"video"  mimeType:@"video/quicktime"];
                                                            }
                                                        } ] ;
    
    AFHTTPRequestOperation* operation   = [ [ AFHTTPRequestOperation alloc ] initWithRequest : request ] ;
    
    [ client registerHTTPOperationClass : [ AFHTTPRequestOperation class ] ] ;
    [ operation setCompletionBlockWithSuccess : ^( AFHTTPRequestOperation* _operation, id _responseObject ) {
        NSString* string = [ [ NSString alloc ] initWithData : _responseObject encoding : NSUTF8StringEncoding ] ;
		NSLog( @"%@", string ) ;
        
        // Response Object ;
        id responseObject   = [ NSJSONSerialization JSONObjectWithData : _responseObject
                                                               options : kNilOptions
                                                                 error : nil ] ;
        
        // Success ;
        if( _success )
        {
            _success( responseObject ) ;
        }
        
    } failure : ^( AFHTTPRequestOperation* _operation, NSError* _error ) {
        
        NSLog( @"%@", _error.description ) ;
        
        // Failture ;
        if( _failure )
        {
            _failure( _error ) ;
        }
    } ] ;
    
    [ operation start ] ;
}

- ( void ) signup : ( NSString* ) _username
         password : ( NSString* ) _password
            email : ( NSString* ) _email
            photo : ( NSData* ) _photo
        successed : ( void (^)( id _responseObject ) ) _success
          failure : ( void (^)( NSError* _error ) ) _failure;
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _username          forKey : @"username" ] ;
    [ params setObject : _password          forKey : @"password" ] ;
    [ params setObject : _email             forKey : @"email" ] ;
    [ params setObject : _photo             forKey : @"photo" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_SIGNUP photo:_photo success : _success failure : _failure ] ;
}

- ( void ) login : ( NSString* ) _username
        password : ( NSString* ) _password
       successed : ( void (^)( id _responseObject ) ) _success
         failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _username          forKey : @"username" ] ;
    [ params setObject : _password          forKey : @"password" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_LOGIN  success : _success failure : _failure ] ;
}

- ( void ) getprofile : ( NSString* ) _userid
                   me : ( NSString* ) _me
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure;
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _userid          forKey : @"userid" ] ;
    [ params setObject : _me          forKey : @"me" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_GETPROFILE  success : _success failure : _failure ] ;
}

- ( void ) addpost : ( NSString* ) _projectid
         daynumber : ( NSString* ) _daynumber
              date : ( NSString* ) _date
             video : ( NSData* ) _video
             photo : ( NSData* ) _photo
         successed : ( void (^)( id _responseObject ) ) _success
           failure : ( void (^)( NSError* _error ) ) _failure;
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _projectid             forKey : @"projectid" ] ;
    [ params setObject : _daynumber             forKey : @"daynumber" ] ;
    [ params setObject : _date                  forKey : @"date" ] ;
    
    // Web Service ;
    [ self sendToService : params action :WEBAPI_ADDPOST  photo:_photo video:_video success : _success failure : _failure ] ;
}

- ( void ) like : ( NSString* ) _userid
         postid : ( NSString* ) _postid
         action : ( NSString* ) _action
      successed : ( void (^)( id _responseObject ) ) _success
        failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _userid             forKey : @"userid" ] ;
    [ params setObject : _postid             forKey : @"postid" ] ;
    [ params setObject : _action             forKey : @"action" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_LIKE  success : _success failure : _failure ] ;
}

- ( void ) getcomment : ( NSString* ) _postid
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _postid             forKey : @"postid" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_GETCOMMENT  success : _success failure : _failure ] ;
}

- ( void ) addcomment : ( NSString* ) _postid
               userid : ( NSString* ) _userid
              comment : ( NSString* ) _comment
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _postid             forKey : @"postid" ] ;
    [ params setObject : _userid             forKey : @"userid" ] ;
    [ params setObject : _comment            forKey : @"comment" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_ADDCOMMENT  success : _success failure : _failure ] ;
}

- ( void ) loadproject : ( NSString* ) _userid
              category : ( NSString* ) _category
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure;
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _userid                forKey : @"userid" ] ;
    [ params setObject : _category              forKey : @"category" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_LOADPROJECT  success : _success failure : _failure ] ;
}

- ( void ) editprofile : ( NSString* ) _userid
                 query : ( NSString* ) _query
                 pdata : ( NSData* ) _pdata
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _userid             forKey : @"userid" ] ;
    [ params setObject : _query             forKey : @"query" ] ;
    
    if (_pdata)
    {
        [ params setObject : @"1"             forKey : @"photo" ] ;
        [ self sendToService : params action : WEBAPI_EDITPROFILE photo:_pdata success : _success failure : _failure ] ;
    }
    else
    {
        // Web Service ;
        [ self sendToService : params action : WEBAPI_EDITPROFILE  success : _success failure : _failure ] ;
    }
}

- ( void ) getmyproject : ( NSString* ) _userid
              successed : ( void (^)( id _responseObject ) ) _success
                failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _userid             forKey : @"userid" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_GETMYPROJECT  success : _success failure : _failure ] ;
}

- ( void ) updateproject : ( NSString* ) _projectid
                   query : ( NSString* ) _query
               successed : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _query             forKey : @"query" ] ;
    [ params setObject : _projectid             forKey : @"projectid" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_UPDATEPROJECT  success : _success failure : _failure ] ;
}

- ( void ) deleteproject : ( NSString* ) _projectid
               successed : ( void (^)( id _responseObject ) ) _success
                 failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _projectid             forKey : @"projectid" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_DELETEPROJECT  success : _success failure : _failure ] ;
}

- ( void ) follow : ( NSString* ) _useridfrom
         useridto : ( NSString* ) _useridto
           action : ( NSString* ) _action
        successed : ( void (^)( id _responseObject ) ) _success
          failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _useridfrom            forKey : @"useridfrom" ] ;
    [ params setObject : _useridto              forKey : @"useridto" ] ;
    [ params setObject : _action                forKey : @"action" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_FOLLOW  success : _success failure : _failure ] ;
}

- ( void ) addproject : ( NSString* ) _userid
                title : ( NSString* ) _title
             category : ( NSString* ) _category
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure;
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _userid                forKey : @"userid" ] ;
    [ params setObject : _title                 forKey : @"title" ] ;
    [ params setObject : _category              forKey : @"category" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_ADDPROJECT  success : _success failure : _failure ] ;
}

- ( void ) getnotifications : ( NSString* ) _userid
                  successed : ( void (^)( id _responseObject ) ) _success
                    failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _userid            forKey : @"userid" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_GETNOTIFICATION  success : _success failure : _failure ] ;
}

- ( void ) getpost : ( NSString* ) _userid
            postid : ( NSString* ) _postid
         successed : ( void (^)( id _responseObject ) ) _success
           failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _userid            forKey : @"userid" ] ;
    [ params setObject : _postid            forKey : @"postid" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_GETPOST  success : _success failure : _failure ] ;
}

- ( void ) getpassword : ( NSString* ) _email
             successed : ( void (^)( id _responseObject ) ) _success
               failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _email            forKey : @"email" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_GETPASSWORD  success : _success failure : _failure ] ;
}

- ( void ) report : ( NSString* ) _content
        successed : ( void (^)( id _responseObject ) ) _success
          failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _content            forKey : @"content" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_REPORT  success : _success failure : _failure ] ;
}

- ( void ) deletepost : ( NSString* ) _postid
            successed : ( void (^)( id _responseObject ) ) _success
              failure : ( void (^)( NSError* _error ) ) _failure
{
    // Params ;
    NSMutableDictionary*    params  = [ NSMutableDictionary dictionary ] ;
    [ params setObject : _postid            forKey : @"postid" ] ;
    
    // Web Service ;
    [ self sendToService : params action : WEBAPI_DELETPOST  success : _success failure : _failure ] ;
}
@end
