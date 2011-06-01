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

	public class Utils
	{
		
		/**
		 * @brief Represents the bytes in a ByteArray as hexadecimal values for printing
		 * @param bytearray The ByteArray to be translated into hexadecimal (bytearray.position is left unchanged)
		 * @return A String containing the hexadecimal representation of the parameter 
		 */
		public static function byteArrayToHex( bytearray : ByteArray ) : String {
			var str : String = new String;
			for( var i : int = 0; i < bytearray.length; ++i ) {
				var tmp : String = bytearray[i].toString(16);
				if ( tmp.length < 2 ) {
					tmp = "0" + tmp;
				}
				str += "\\x" + tmp;
			}
			return str;
		}
		
		/**
		 * @brief Produce a string representation for an object
		 * @param object The object to be represented in the string
		 * @return A string showing key-values pairs
		 */
		public static function objectToString( object : Object ) : String {
			var str : String = "";
			for( var key : String in object) {
				if( key is ObjectID ) {
					str += key + ": " + ( object[key] as ObjectID ).toString() + "\n";
				} else if( key is Int64 ) {
					str += key + ": " + ( object[key] as Int64 ).toString() + "\n";
				} else {
					str += key + ": " + object[key] + "\n";
				}
			}
			return str;
		}
		
	}
}