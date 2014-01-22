//
//  OpenALSoundController.m
//  Morse Code
//
//  Created by Rick Wu on 7/01/2014.
//  Copyright (c) 2014 Rick Wu. All rights reserved.
//

#import "OpenALSoundController.h"

@interface OpenALSoundController()
@end

@implementation OpenALSoundController
{
    // To set up OpenAL, you will need a device, a context, a source and a buffer
    ALCdevice* openALDevice; //The device represents a physical sound device, such as a sound card
    ALCcontext* openALContext; //The context keeps track of the current OpenAL state
    ALuint outputSource; //A source in OpenAL emits sound
    ALuint outputBuffer; //Buffers hold audio data
    AudioFileID afid; // An opaque identifier that Audio File Services uses
}

//
// This method sets up the sound resource to be played
// Implementation refer to
// http://devnulldb.blogspot.com.au/2012/07/how-to-set-up-openal-and-play-sound.html
//
- (void) initResource
{
    // To set up OpenAL, you will need a device, a context, a source and a buffer
    
    // The device represents a physical sound device, such as a sound card
    // Create a device with openALDevice, passing NULL to indicate you wish to use the default device:
    openALDevice = alcOpenDevice(NULL);
    // use alGetError at any time to see if there is a problem with the last OpenAL call
    ALenum err = alGetError();
    if (AL_NO_ERROR != err)
    {
        NSLog(@"Error %d when attemping to open device", err);
    }
    
    // The context keeps track of the current OpenAL state.
    // Use openALContext to create a context and associate it with your device
    openALContext = alcCreateContext(openALDevice, NULL);
    // Then make the context current
    alcMakeContextCurrent(openALContext);
    
    // A source in OpenAL emits sound.
    // Use alGenSources to generate one or more sources, noting their identifiers (either a single ALuint or an array).
    // This allocates memory:
    alGenSources(1, &outputSource);
    
    // You can set various source parameters using alSourcef
    alSourcef(outputSource, AL_PITCH, 0.6f);
    //alSourcef(outputSource, AL_GAIN, 1.0f);
    
    // Buffers hold audio data.
    // Use alGenBuffers to generate one or more buffers:
    alGenBuffers(1, &outputBuffer);
    
    // Now we have a buffer we can put audio data into, a source that can emit that data,
    // a device we can use to output the sound, and a context to keep track of state.
    // The next step is to get audio data into the buffer.
    // First we'll get a reference to the audio file:
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"caf"];
    NSURL* fileUrl = [NSURL fileURLWithPath:filePath];
    
    // Now we need to open the file and get its AudioFileID,
    // which is an opaque identifier that Audio File Services uses:
    OSStatus openResult = AudioFileOpenURL((__bridge CFURLRef)fileUrl, kAudioFileReadPermission, 0, &afid); //The use of __bridge is only necessary if you are using ARC. The literal value 0 indicates that we're not providing a file type hint. We don't need to provide a hint because the extension will suffice.
    if (0 != openResult)
    {
        NSLog(@"An error occurred when attempting to open the audio file %@: %ld", filePath, openResult);
        return;
    }
    
    // Now we have to determine the size of the audio file. To do this, we will use AudioFileGetProperty.
    // This function takes the AudioFileID we got from AudioFileOpenURL,
    // a constant indicating the property we're interested in,
    // and a reference to a variable containing the size of the property value.
    // The reason you pass this by reference is because AudioFileGetProperty will set it to the actual property value.
    UInt64 fileSizeInBytes = 0;
    UInt32 propSize = sizeof(fileSizeInBytes);
    OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propSize, &fileSizeInBytes);
    if (0 != getSizeResult)
    {
        NSLog(@"An error occurred when attempting to determine the size of audio file %@: %ld", filePath, getSizeResult);
    }
    // Note that kAudioFilePropertyAudioDataByteCount is an unsigned 64-bit integer,
    // but I downcast it to an unsigned 32-bit integer.
    // The reason I've done this is because we can't use the 64-bit version with the code coming up.
    // Hopefully your audio files aren't long enough for this to matter. ;-)
    UInt32 bytesRead = (UInt32)fileSizeInBytes;
    
    // Read data from the file and put it into the output buffer
    // The first thing to do is to allocate some memory to hold the file contents:
    void* audioData = malloc(bytesRead);
    // Then read the file.
    // We pass the AudioFileID, false to indicate that we don't want to cache the data,
    // 0 to indicate that we want to read the file from the beginning, a reference to bytesRead,
    // and the pointer to the memory location where the file data should be placed.
    // After the data is read, bytesRead will contain the actual number of bytes read.
    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &bytesRead, audioData);
    if (0 != readBytesResult)
    {
        NSLog(@"An error occurred when attempting to read data from audio file %@: %ld", filePath, readBytesResult);
    }
    
    // Close the file:
    AudioFileClose(afid);
    
    // Copy the data from file buffer into OpenAL buffer:
    alBufferData(outputBuffer, AL_FORMAT_STEREO16, audioData, bytesRead, 44100);
    
    // Now that we've copied the data we can clean up file buffer:
    if (audioData)
    {
        free(audioData);
        audioData = NULL;
    }
    
    // Then we can attach the buffer to the source:
    alSourcei(outputSource, AL_BUFFER, outputBuffer);
}

/*
 * This method need to be called when the sound is not needed anymore
 */
- (void) releaseResource
{
    // Delete source and buffers, destroy the context and close the device
    alDeleteSources(1, &outputSource);
    alDeleteBuffers(1, &outputBuffer);
    alcDestroyContext(openALContext);
    alcCloseDevice(openALDevice);
}

- (void) playSound
{
    alSourcePlay(outputSource);
}

- (void) stopSound
{
    alSourceStop(outputSource);
}

- (void) playSoundForDuration: (NSNumber *) time
{
    [self playSound];
    float val = [time floatValue];
    [self performSelector:@selector(stopSound) withObject:nil afterDelay:val];
}

@end
