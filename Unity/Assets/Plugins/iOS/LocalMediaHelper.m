//
//  LocalMediaHelper.m
//  JFunGameSDKDemo
//
//  Created by yons on 2019/7/31.
//  Copyright © 2019 jfungame. All rights reserved.
//

#import "LocalMediaHelper.h"
#import "MediaPlayer/MediaPlayer.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#define UNITY_OBJECT "LocalMediaHelperObject"
#define UNITY_OBJECT_MESSAGE "OnGetFilePath"
void    UnitySendMessage(const char* obj, const char* method, const char* msg);

@implementation LocalMediaHelper

static BOOL working = FALSE;

+(NSString*)GetAllMusicReturnJson
{
    MPMediaQuery* query = [MPMediaQuery  songsQuery];
    NSMutableArray* root = [NSMutableArray arrayWithCapacity:128];
    
    NSArray *itemsQuery = [query items];
    for (MPMediaItem *song in itemsQuery) {
        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
        if(songTitle == nil)songTitle = @"unknow";
        NSString *songArtist = [song valueForProperty: MPMediaItemPropertyArtist];
        if(songArtist == nil)songArtist = @"unknow";
        NSURL* songAssetURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
        NSString* songAssetURLString = [songAssetURL absoluteString];
        //encode to base64
        songAssetURLString = [[songAssetURLString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
      
        
        [root addObject:@{@"id":songAssetURLString, @"title":songTitle, @"artist":songArtist}];
    }
    
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:root options:NSJSONWritingPrettyPrinted  error:nil];
    NSString *json = [[NSString alloc]initWithData:tempData encoding:NSUTF8StringEncoding];
    return json;
}

+(void)ReportResult:(NSString*)ID withResult:(NSString*)path
{
    NSDictionary* result = @{@"id":ID, @"path":path};
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted  error:nil];
    NSString *json = [[NSString alloc]initWithData:tempData encoding:NSUTF8StringEncoding];
    
    UnitySendMessage(UNITY_OBJECT, UNITY_OBJECT_MESSAGE, [json UTF8String]);
    
}

+(void)GetPathByID:(NSString*)ID
{
    NSString* dirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* filePath = [dirPath stringByAppendingString:[NSString stringWithFormat:@"/%@.m4a", ID]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath])
    {
        [self ReportResult:ID withResult:filePath];
        return;
    }
    
    
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:ID options:0];
    NSString* urlString = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
    NSURL* assetURL = [NSURL URLWithString:urlString];
    if(assetURL == nil)
    {
        [self ReportResult:ID withResult:@""];
        return;
    }
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    if(songAsset == nil)
    {
        [self ReportResult:ID withResult:@""];
        return;
    }
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: songAsset
                                      presetName: AVAssetExportPresetAppleM4A];
    
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    
    NSError *error1;
    NSURL* exportURL = [NSURL fileURLWithPath:filePath];
    
    exporter.outputURL = exportURL;
    
    working = TRUE;
    [exporter exportAsynchronouslyWithCompletionHandler:^
     {
      
         int exportStatus = exporter.status;
         
         switch (exportStatus) {
                 
             case AVAssetExportSessionStatusFailed: {
                 
                  [self ReportResult:ID withResult:@""];
                 break;
             }
                 
             case AVAssetExportSessionStatusCompleted: {
                 
                  [self ReportResult:ID withResult:filePath];
                 break;
             }
                 
             case AVAssetExportSessionStatusUnknown: {
                
                 break;
             }
             case AVAssetExportSessionStatusExporting: {
                
                 break;
             }
                 
             case AVAssetExportSessionStatusCancelled: {
                  [self ReportResult:ID withResult:@""];
                 break;
             }
                 
             case AVAssetExportSessionStatusWaiting: {
                
                 break;
             }
                 
             default:
             {
                 break;
             }
         }
         
     }];
    
}
@end



const char* GetAllMusicReturnJson()
{
    return strdup([[LocalMediaHelper GetAllMusicReturnJson] UTF8String]);
}

void GetMusicPathByID(const char* ID)
{
    [LocalMediaHelper GetPathByID:[NSString stringWithUTF8String:ID]];
}


