//
//  ViewController.m
//  k10SetupInputAudio
//
//  Created by macbook on 2024-07-16.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@implementation ViewController
{
    BOOL isRecording;
    BOOL isPlaying;
    AVAudioRecorder *recorder;
    AVPlayer *player;
}
@synthesize setupButton, recordingButton, playingButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isRecording = NO;
    isPlaying = NO;
    playingButton.titleLabel.text = @"Start";
    
}

- (void)setupAudioSession {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    NSArray<AVAudioSessionPortDescription *> *inputs = [audioSession availableInputs];
    AVAudioSessionPortDescription *builtInMic = nil;
    
    NSLog(@"%@", inputs);
    NSLog(@"%lu", (unsigned long)[inputs count]);
    for (AVAudioSessionPortDescription *input in inputs) {
        if ([input.portType isEqualToString:AVAudioSessionPortBuiltInMic]) {
            builtInMic = input;
            break;
        }
    }
    
    if (builtInMic) {
        [audioSession setPreferredInput:builtInMic error:&error];
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    } else {
        NSLog(@"mic not found");
    }
    
    [audioSession setActive:YES error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
}

-(IBAction)setupPreset:(id)sender{
    [self setupAudioSession];
}

-(IBAction)recordingPreset:(id)sender{
    if (!isRecording){
        dispatch_async(dispatch_get_main_queue(), ^{
            recordingButton.titleLabel.text = @"Stop Recording";
            [self startRecorfing];
        });
        isRecording = YES;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            recordingButton.titleLabel.text = @"Start Recording";
            [self stopRecording];
        });
        isRecording = NO;
    }
    
    
}
-(IBAction)playingPreset:(id)sender{
    if (!isRecording){
        dispatch_async(dispatch_get_main_queue(), ^{
            playingButton.titleLabel.text = @"Start";
            [self startPlaying];
        });
        isPlaying = YES;
    } else {

        [self stopPlaying];
        isPlaying = NO;
    }
    
    
}

-(void)startRecorfing{
    NSArray *paths = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"newRec.m4a", nil];
    NSURL *audioUrl = [NSURL fileURLWithPathComponents:paths];
    AVAudioSession *session = [[AVAudioSession alloc]init];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                   error:nil];
    NSMutableDictionary *setting = [[NSMutableDictionary alloc]init];
    [setting setValue:[NSNumber numberWithInteger:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [setting setValue:[NSNumber numberWithInteger:1] forKey:AVNumberOfChannelsKey];
    
    recorder = [[AVAudioRecorder alloc]initWithURL:audioUrl settings:setting error:nil];
    [recorder prepareToRecord];
    [recorder record];
    
    
}
-(void)stopRecording{
    AVAudioSession *session = [[AVAudioSession alloc]init];
    [recorder stop];
    [session setActive:NO error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        playingButton.titleLabel.text = @"Stop";
        
    });
}
-(void)startPlaying{
    if(!recorder.recording){
        player = [[AVPlayer alloc]initWithURL:recorder.url];
        [player play];
    }
}
-(void)stopPlaying{
    player = [[AVPlayer alloc]initWithURL:recorder.url];
    [player pause];
}
@end
