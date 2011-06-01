/*
 * Copyright (c) 2010 Claudio Alberto Andreoni.
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
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

package org.serialization.bson
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.controls.Alert;

	public class Int64 {
		
		// BSON is little-endian
		private var rep : ByteArray = new ByteArray();
		
		/**
		 * @brief Create a new Int64
		 * @param bytearray A ByteArray with 8 bytes containing the Int64
		 */
		public function Int64 ( bytearray : ByteArray ) : void {
			rep.endian = Endian.LITTLE_ENDIAN;
			for( var i : int = 0; i < 8; ++i ) {
				rep[i] = bytearray.readByte();
			}
		}
		
		
		public function dup() : Int64 {
			var bin : ByteArray = new ByteArray();
			bin.endian = Endian.LITTLE_ENDIAN;
			for( var i : int = 0; i < 8; ++i ) {
				bin[i] = rep[i];
			}
			return new Int64( bin );
		}
		
		
		/**
		 * @brief Create a new Int64
		 * @param int32 A 32-bit int
		 */
		public static function fromInt ( int32 : int ) : Int64 {
			var ret : Int64 = Int64.ZERO;
			ret.rep.position = 0;
			ret.rep.writeInt( int32 );
			if( ret.rep[3] & 128 == 128 ) {
				for( var i : int = 4; i < 8; ++i ) {
					ret.rep[i] = 0xff;
				}
			} else {
				for( var j : int = 4; j < 8; ++j ) {
					ret.rep[j] = 0x00;
				}
			}
			return ret;
		}
		
		
		
		/**
		 * @brief Set the value of this Int64
		 * @param bytearray A ByteArray with 8 bytes containing the Int64
		 */
		public function setFromBytes( bytearray : ByteArray ) : void {
			rep = bytearray;
			rep.endian = Endian.LITTLE_ENDIAN;
		}
		
		
		
		/**
		 * @brief Get the value of this Int64
		 * @return An 8-byte ByteArray containing the Int64 in little-endian format
		 */
		public function getAsBytes() : ByteArray {
			return dup().rep;
		}
		
		internal function getLowPosPart() : uint {
			var obj : Int64;
			if( negative() ) {
				obj = Int64.twoComp( this );
			} else {
				obj = dup();
			}
			obj.rep.position = 0;
			return obj.rep.readUnsignedInt();
		}
		
		internal function getHighPosPart() : uint {
			var obj : Int64;
			if( negative() ) {
				obj = Int64.twoComp( this );
			} else {
				obj = dup();
			}
			obj.rep.position = 4;
			return obj.rep.readUnsignedInt();
		}
		
		public static function get ZERO() : Int64 {
			var bin : ByteArray = new ByteArray();
			bin.endian = Endian.LITTLE_ENDIAN;
			bin.length = 8;
			for( var i : int = 0; i < 8; ++i ) {
				bin[i] = 0;
			}
			return new Int64( bin );
		}
		
		public static function get ONE() : Int64 {
			var bin : ByteArray = new ByteArray();
			bin.endian = Endian.LITTLE_ENDIAN;
			bin.length = 8;
			bin[0] = 1;
			for( var i : int = 1; i < 8; ++i ) {
				bin[i] = 0;
			}
			return new Int64( bin );
		}
		
		private function addToByte( val : int, id : int ) : void {
			
			// index out of range
			if( id < 0 || id >= 8 ) {
				return;
			}
			
			// neutral value
			if( val == 0 ) {
				return;
			}
			
			var sum : int = rep[id] + val;
			rep[id] = sum % 256;
			addToByte( Math.floor( sum / 256 ), id+1 );
		}
		
		public static function invBits( op1 : Int64 ) : Int64 {
			var res : Int64 = Int64.ZERO;
			for( var i : int = 0; i < 8; ++i ) {
				res.rep[i] = op1.rep[i] ^ 0xff;
			}
			return res;
		}
		
		public static function twoComp( op1 : Int64 ) : Int64 {
			return Int64.add( Int64.ONE, Int64.invBits( op1 ) ); 
		}
		
		public function negative() : Boolean {
			if( rep[7] & 128 == 128) {
				return true;
			} else {
				return false;
			}
		}
		
		public function inc() : void {
				addToByte( 1, 0 );
		}
		
		public static function add( op1 : Int64, op2 : Int64 ) : Int64 {
			var ret : Int64 = Int64.ZERO;
			for( var i : int = 0; i < 8; ++i ) {
				ret.addToByte( op1.rep[i] + op2.rep[i], i );
			}
			return ret;
		}
		
		public static function sub( op1 : Int64, op2 : Int64 ) : Int64 {
			return Int64.add( op1, Int64.twoComp( op2 ) );
		}
		
		public static function mul( op1 : Int64, op2 : Int64 ) : Int64 {
			var ret : Int64 = Int64.ZERO;
			var negate : Boolean = false;
			
			if( op1.negative() ) {
				negate = !negate;
				op1 = Int64.twoComp( op1 );
			}
			if( op2.negative() ) {
				negate = !negate;
				op2 = Int64.twoComp( op2 );
			}
			
			for( var m : int = 0; m < 8; ++m ) {
				for( var n : int = 0; n < 8; ++n ) {
					ret.addToByte( op1.rep[n] * op2.rep[m], m+n );
				}
			}
			
			if( negate ) {
				ret = Int64.twoComp( ret );
			}
			
			return ret;
		}
		
		public static function div( op1 : Int64, op2 : Int64 ) : Int64 {
			var div : Int64 = Int64.ZERO;
			var negate : Boolean = false;
			
			if( op1.negative() ) {
				negate = !negate;
				op1 = Int64.twoComp( op1 );
			}
			if( op2.negative() ) {
				negate = !negate;
				op2 = Int64.twoComp( op2 );
			}
			
			var rem : Int64 = op1;
			
			while( Int64.cmp( rem, op2 ) >= 0 ) {
				rem = Int64.sub( rem, op2 );
				div.inc();
			}
			
			if( negate ) {
				div = Int64.twoComp( div );
			}
			
			return div;
		}
		
		public static function rem( op1 : Int64, op2 : Int64 ) : Int64 {
			var negate : Boolean = false;
			
			if( op1.negative() ) {
				negate = !negate;
				op1 = Int64.twoComp( op1 );
			}
			if( op2.negative() ) {
				negate = !negate;
				op2 = Int64.twoComp( op2 );
			}
			
			var rem : Int64 = op1;
			
			while( Int64.cmp( rem, op2 ) >= 0 ) {
				rem = Int64.sub( rem, op2 );
			}
			
			if( negate ) {
				rem = Int64.twoComp( rem );
			}
			
			return rem;
		}
		
		/**
		 * @return <b>-1</b> if op1 < op2, <b>0</b> if op1 == op2, and <b>1</b> if op1 > op2,  
		 */
		public static function cmp( op1 : Int64, op2 : Int64 ) : Number {
			if( !op1.negative() && !op2.negative() ) { // both positive
				
				for( var i : int = 7; i >= 0; --i ) {
					if( op1.rep[i] > op2.rep[i] ) {
						return 1;
					} else if( op1.rep[i] < op2.rep[i] ) {
						return -1;
					}
				}
				// the two numbers are equal
				return 0;
				
			} else if ( !op1.negative() && !op2.negative() ) { // both negative
				
				op1 = Int64.twoComp( op1 );
				op2 = Int64.twoComp( op2 );
				for( var j : int = 7; i >= 0; --j ) {
					if( op1.rep[j] > op2.rep[j] ) {
						return -1;
					} else if( op1.rep[j] < op2.rep[j] ) {
						return 1;
					}
				}
				// the two numbers are equal
				return 0;
				
			} else if ( !op1.negative() && op2.negative() ) { // op1 non-negative, op2 negative
				
				return 1;
				
			} else { // op1 negative, op2 non-negative
				
				return -1;
				
			}
		}
	
		
		public function toString() : String {
			var str : String = "";
			for( var i : int = 0; i < 8; ++i ) {
				str = str.concat( rep[i].toString(2) + " " );
			}
			return str;
		}
	}
}
