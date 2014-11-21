//
//  Protocol.h
//  RPI_iOS_Server
//
//  Created by William Clark on 11/21/14.
//
//

#ifndef RPI_iOS_Server_Protocol_h
#define RPI_iOS_Server_Protocol_h

// shared with client //

#define PACKET_SIZE 3 // opcode, x, y

typedef enum Opcodes {
    SET_POSITION = 0xff
} Opcodes;

#endif
