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

	public class Binary
	{
		
		public static var BINARY_GENERIC : int = 0x00;
		public static var FUNCTION : int = 0x01;
		public static var BINARY_OLD : int = 0x02;
		public static var UUID : int = 0x03;
		public static var MD5 : int = 0x05;
		public static var USER_DEFINED : int = 0x80;
		
		public var subtype : int;
		public var data : ByteArray;
		
		public function Binary( subtype : int, data : ByteArray ) {
			this.subtype = subtype;
			this.data = data;
			data.endian = Endian.LITTLE_ENDIAN;
		}
	}
}
