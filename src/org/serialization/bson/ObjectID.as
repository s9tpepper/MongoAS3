/*
 * Copyright (c) 2010 Claudio Alberto Andreoni.
 * Modifications by Eric Socolofsky: http://transmote.com.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

package org.serialization.bson {
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class ObjectID {
		private static var incrementer : uint = Math.random() * uint.MAX_VALUE;
		private static var machineAndProcessID : ByteArray = null;

		// BSON is little-endian
		private var rep : ByteArray;
		private var time : uint;

		/**
		 * @brief Create a new ObjectID
		 * @param bytearray A little-endian, 12-byte ByteArray containing the ID
		 */
		public function ObjectID( bytearray : ByteArray = null ) :void {
			if (bytearray == null) {
				bytearray = generateObjectID();
			}
			setFromBytes( bytearray );
		}



		/**
		 * @brief Set the value of this ObjectID
		 * @param bytearray A little-endian, 12-byte ByteArray containing the ID
		 */
		public function setFromBytes( bytearray : ByteArray ) :void {
			rep = new ByteArray();
			for ( var i : int = 0; i < 12; ++i ) {
				rep[i] = bytearray.readByte();
			}
			
			time = rep.readUnsignedInt();
			rep.position = 0;
		}



		/**
		 * @brief Get the value of this ObjectID
		 * @return A little-endian, 12-byte ByteArray containing the ID
		 */
		public function getAsBytes() : ByteArray {
			return rep;
		}

		public function toString() : String {
			var str:String = "";
			for ( var i : int = 0; i < 12; ++i ) {
				str += rep[i].toString( 16 );
			}
			return str;
		}
		
		public function toDate() : Date {
			return new Date( time * 1000 );
		}
		
		private function generateObjectID() :ByteArray {
			// from: http://www.mongodb.org/display/DOCS/Object+IDs
			
			// 4-byte timestamp
			time = new Date().getTime();
			var timeBytes:ByteArray = new ByteArray();
			timeBytes.endian = Endian.BIG_ENDIAN;
			timeBytes.writeInt( time );
			timeBytes.length = 4;	// truncate as needed
			
			// 3-byte machine id + 2-byte process id
			if ( machineAndProcessID == null ) {
				generateMachineID();
			}
			
			// 3-byte increment
			var incBytes:ByteArray = new ByteArray();
			incBytes.endian = Endian.BIG_ENDIAN;
			incBytes.writeUnsignedInt( incrementer++ );
			incBytes.length = 3;		// truncate as needed
			
			var idBytes:ByteArray = new ByteArray();
			idBytes.writeBytes( timeBytes );
			idBytes.writeBytes( machineAndProcessID );
			idBytes.writeBytes( incBytes );
			
			idBytes.position = 0;
			return idBytes;
		}
		
		private function generateMachineID() :void {
			machineAndProcessID = new ByteArray();
			machineAndProcessID.endian = Endian.LITTLE_ENDIAN;
			
			var useRandom:Boolean = true;
			for each ( var i : NetworkInterface in NetworkInfo.networkInfo.findInterfaces() ) {
				if ( i.hardwareAddress ) {
					machineAndProcessID.writeUTFBytes( i.hardwareAddress );
					useRandom = false;
					break;
				}
			}
			
			if ( useRandom ) {
				// if no NetworkInterfaces with valid hardware addresses found, use random
				var randomMachineID : uint = Math.floor( Math.random() * uint.MAX_VALUE );
				machineAndProcessID.writeUnsignedInt( randomMachineID );
			}
			
			machineAndProcessID.length = 3;		// truncate as needed
			
			// not possible to get process id from flash without launching a NativeProcess,
			// which requires AIR application with extendedDesktop profile.
			// so, use a random.
			var processID:uint = Math.floor( Math.random() * uint.MAX_VALUE );
			machineAndProcessID.writeUnsignedInt( processID );
			
			machineAndProcessID.length = 5;		// truncate as needed
		}
	}
}
