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
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
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

	public class ObjectID {
		
		// BSON is little-endian
		private var rep : ByteArray;
		
		/**
		 * @brief Create a new ObjectID
		 * @param bytearray A little-endian, 12-byte ByteArray containing the ID
		 */
		public function ObjectID ( bytearray : ByteArray ) : void {
			setFromBytes( bytearray );
		}
		
		
		
		/**
		 * @brief Set the value of this ObjectID
		 * @param bytearray A little-endian, 12-byte ByteArray containing the ID
		 */
		public function setFromBytes( bytearray : ByteArray ) : void {
			rep = new ByteArray();
			for ( var i : int = 0; i < 12; ++i ) {
				rep[i] = bytearray.readByte();
			}
		}

		
		
		/**
		 * @brief Get the value of this ObjectID
		 * @return A little-endian, 12-byte ByteArray containing the ID
		 */
		public function getAsBytes() : ByteArray {
			return rep;
		}
		
		public function toString() : String {
			var str : String = "";
			for ( var i : int = 0; i < 12; ++i ) {
				str += rep[i].toString( 16 );
			}
			return str;
		}
	}
}