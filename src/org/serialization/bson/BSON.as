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
	
	import as3.mongo.db.document.Document;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import flashx.textLayout.tlf_internal;
	
	public class BSON {
		
		// the BSON types
		public static const BSON_TERMINATOR : uint = 0x00;
		public static const BSON_DOUBLE : uint = 0x01;
		public static const BSON_STRING : uint = 0x02;
		public static const BSON_DOCUMENT : uint = 0x03;
		public static const BSON_ARRAY : uint = 0x04;
		public static const BSON_BINARY : uint = 0x05;
		// 0x06 is deprecated
		public static const BSON_OBJECTID : uint = 0x07;
		public static const BSON_BOOLEAN : uint = 0x08;
		public static const BSON_UTC : uint = 0x09;
		public static const BSON_NULL : uint = 0x0a;
		// public static const BSON_REGEXP : uint = 0x0b;
		// 0x0c is deprecated
		// public static const BSON_JS : uint = 0x0d;
		// public static const BSON_SYMBOL : uint = 0x0e;
		// public static const BSON_SCOPEDJS : uint = 0x0f;
		public static const BSON_INT32 : uint = 0x10;
		// public static const BSON_TIMESTAMP : uint = 0x11;
		public static const BSON_INT64 : uint = 0x12;
		// public static const BSON_MAX : uint = 0x7f;
		// public static const BSON_MIN : uint = 0xff;
		
		
		/**
		 * @brief Produce the BSON representation of an Object
		 * @param document The object to be represented in BSON
		 * @return A BSON representation of the parameter, or null if the parameter is null
		 * The position of the returned ByteArray points to the beginning of the document
		 */
		public static function encode( document : Object ) : ByteArray {
			if( document == null ) { // cannot encode a null document
				return null;
			}
			var res : ByteArray = toBSONDocument( document );
			res.position = 0;
			return res;
		}
		
		/**
		 * @brief Turn a BSON document into an Object
		 * @param document A BSON document
		 * @return An Object representing the BSON document
		 * document.position is left at the end of the parsed document
		 */
		public static function decode( document : ByteArray ) : Object {
			document.endian = Endian.LITTLE_ENDIAN;
			var res : Object = fromBSONDocument( document );
			return res;
		}
		
		
		
		/**
		 * @brief Determines the type of an object and parses it
		 * @param object An AS object to represent in BSON
		 * @return An array with two items: 0 = BSON object type, 1 = BSON representation (as ByteArray)
		 */
		private static function parseItem ( object : * ) : Array {
			
			// result
			var type : int = new int();
			var value : ByteArray = new ByteArray();
			
			// determine what kind of object we are serializing
			
			if( object == null ) {
				
				type = BSON_NULL;
				
			} else if ( object is String ) {
				
				type = BSON_STRING;
				value = toBSONString( object as String );
				
			} else if ( object is Boolean ) {
				
				type = BSON_BOOLEAN;
				value = toBSONBoolean( object as Boolean );
				
			} else if ( object is int ) {
				
				type = BSON_INT32;
				value = toBSONInt32( object as int );
				
			} else if ( object is Int64 ) {
				
				type = BSON_INT64;
				value = toBSONInt64( object as Int64 );
				
			} else if ( object is Number ) {
				
				type = BSON_DOUBLE;
				value = toBSONDouble( object as Number );
				
			} else if ( object is ObjectID ) {
				
				type = BSON_DOUBLE;
				value = toBSONObjectID( object as ObjectID );
				
			} else if ( object is Date ) {
				
				type = BSON_UTC;
				value = toBSONDate( object as Date );
				
			} else if ( object is Binary ) {
				
				type = BSON_BINARY;
				value = toBSONBinary( object as Binary );
			
			} else if ( object is Array ) {
				
				type = BSON_ARRAY;
				value = toBSONArray( object as Array );
				
			} else if ( object is Object ) {
				
				type = BSON_DOCUMENT;
				value = toBSONDocument( object as Object );
				
			} else {
				
				// this should never happen
				trace("parseItem: encountered an unknown object");
				
			}
			
			return [ type, value ];
		}
		
		/**
		 * @brief Compute the BSON representation of an array
		 * @param object An array (instance of Array)
		 * @return The BSON representation of the parameter
		 */
		private static function toBSONArray( object : Array ) : ByteArray {
			var bson : ByteArray = new ByteArray();
			bson.endian = Endian.LITTLE_ENDIAN;
			bson.writeInt(0); // reserve space for the document size
			
			for ( var counter : int = 0; counter < object.length; ++counter ) {
				var parsed : Array = parseItem( object[counter] );
				bson.writeByte( parsed[0] );
				bson.writeMultiByte( counter.toString(), "utf-8" );
				bson.writeByte( BSON_TERMINATOR );
				joinByteArrays( bson, parsed[1] );
			}
			bson.writeByte( BSON_TERMINATOR );
			
			// write the document size at the beginning of the array
			bson.position = 0;
			bson.writeInt( bson.length );
			
			bson.position = 0;
			return bson;
		}
		
		
		/**
		 * @brief Compute the BSON representation of a boolean value
		 * @param object A boolean value
		 * @return The BSON representation of the parameter
		 */
		private static function toBSONBoolean( object : Boolean ) : ByteArray {
			var bson : ByteArray = new ByteArray();
			bson.endian = Endian.LITTLE_ENDIAN;
			bson.writeBoolean( object );
			
			bson.position = 0;
			return bson;
		}
		
		/**
		 * @brief Compute the BSON representation of a 32-bit signed integer
		 * @param object A signed integer
		 * @return The BSON representation of the parameter
		 */
		private static function toBSONInt32( object : int ) : ByteArray {
			var bson : ByteArray = new ByteArray();
			bson.endian = Endian.LITTLE_ENDIAN;
			bson.writeInt( object );
			
			bson.position = 0;
			return bson;
		}
		
		/**
		 * @brief Compute the BSON representation of a 64-bit floating point number
		 * @param object A floating point number
		 * @return The BSON representation of the parameter
		 */
		private static function toBSONDouble( object : Number ) : ByteArray {
			var bson : ByteArray = new ByteArray();
			bson.endian = Endian.LITTLE_ENDIAN;
			bson.writeDouble( object );
			
			bson.position = 0;
			return bson;
		}
		
		/**
		 * @brief Compute the BSON representation of a string
		 * @param object A string
		 * @return The BSON representation of the parameter
		 */
		private static function toBSONString( object : String ) : ByteArray {
			var bson : ByteArray = new ByteArray();
			bson.endian = Endian.LITTLE_ENDIAN;
			
			// find the length of the UTF-8 encoding in bytes
			// thanks to wpntv ( http://github.com/wpntv )
			var utfEncoding : ByteArray = new ByteArray();
			utfEncoding.writeMultiByte( object, "utf-8" );
			
			joinByteArrays( bson, toBSONInt32( utfEncoding.length + 1 ) )
			bson.writeMultiByte( object, "utf-8" );
			bson.writeByte( BSON_TERMINATOR );
			
			bson.position = 0;
			return bson;
		}
		
		
		/**
		 * @brief Compute the BSON representation of a document
		 * @param object An object representing a document
		 * @return The BSON representation of the parameter
		 */
		private static function toBSONDocument( object : Object ) : ByteArray {
			var bson : ByteArray = new ByteArray();
			bson.endian = Endian.LITTLE_ENDIAN;
			bson.writeInt(0); // reserve space for the document size
			
			
			var parsed : Array;
			if (object is Document)
			{
				const document:Document = object as Document;
				for (var i:Number = 0; i < document.totalFields; i++)
				{
					parsed = parseItem( document.getValueAt(i) );
					bson.writeByte( parsed[0] );
					bson.writeMultiByte( document.getKeyAt(i), "utf-8" );
					bson.writeByte( BSON_TERMINATOR );
					joinByteArrays( bson, parsed[1] );
				}
			}
			else
			{
				for ( var sub : String in object ) {
					parsed = parseItem( object[sub] );
					bson.writeByte( parsed[0] );
					bson.writeMultiByte( sub, "utf-8" );
					bson.writeByte( BSON_TERMINATOR );
					joinByteArrays( bson, parsed[1] );
				}
			}
			
			bson.writeByte( BSON_TERMINATOR );
			
			// write the document size at the beginning of the array
			bson.position = 0;
			bson.writeInt( bson.length );
			
			bson.position = 0;
			return bson;
		}
		
		/**
		 * @brief Compute the BSON representation of an ObjectID
		 * @param object An ObjectID
		 * @return The BSON representation of the parameter
		 */
		private static function toBSONObjectID( object : ObjectID ) : ByteArray {
			return object.getAsBytes();
		}
		
		/**
		 * @brief Compute the BSON representation of an Int64
		 * @param object An Int64
		 * @return The BSON representation of the parameter
		 */
		private static function toBSONInt64( object : Int64 ) : ByteArray {
			return object.getAsBytes();
		}
		
		/**
		 * @brief Compute the BSON representation of a Date
		 * @param object A Date
		 * @return The BSON representation of the parameter
		 */
		private static function toBSONDate( object : Date ) : ByteArray {
			var val : Int64;
			var raw : Number = object.time;
			var negative : Boolean = false;
			
			if( raw < 0 ) {
				raw *= -1;
				negative = true;
			}
			
			// 67108864 = 2^26 = half the double's mantissa < 2^32
			// used to fit Numbers in ints
			val = Int64.fromInt( raw / 67108864 );
			val = Int64.mul( val, Int64.fromInt( 67108864 ) );
			val = Int64.add( val, Int64.fromInt( raw % 67108864 ) );
			if( negative ) {
				val = Int64.twoComp( val );
			}
			return val.getAsBytes();
		}
		
		private static function toBSONBinary( object : Binary ) : ByteArray {
			var ret : ByteArray  = new ByteArray();
			// thanks to Михаил for the suggestion
			ret.endian = Endian.LITTLE_ENDIAN;
			if(object.subtype == Binary.BINARY_OLD) {
				ret.writeInt( object.data.length+4 ); // byte list contains another size indicator
				ret.writeByte( object.subtype );
				ret.writeInt( object.data.length );
			} else {
				ret.writeInt( object.data.length ); // size of content
				ret.writeByte( object.subtype );
			}
			joinByteArrays( ret, object.data );
			return ret;
		} 
		
		
		/**
		 * @brief Translate a BSON array into an Array
		 * @param object A BSON array
		 * @return An Array representing the parameter
		 */
		private static function fromBSONArray( bson : ByteArray ) : Array {
			var arr : Array = new Array();
			var length : uint = bson.readInt();
			var type : uint = bson.readByte();
			var count : uint = 0;
			
			while( type != BSON_TERMINATOR ) {
				
				var key : String = readBSONcstring( bson );
				if( key != count.toString() ) {
					trace( "fromBSONArray: incorrect key for array value" );
				}
				
				switch( type ) {
					
					case BSON_DOUBLE:
						
						arr[count] = fromBSONDouble( bson );
						break;
					
					
					case BSON_STRING:
						
						arr[count] = fromBSONString( bson );
						break;
					
					
					case BSON_DOCUMENT:
						
						arr[count] = fromBSONDocument( bson );
						break;
					
					
					case BSON_ARRAY:
						
						arr[count] = fromBSONArray( bson );
						break;
					
					
					case BSON_OBJECTID:
						
						arr[count] = fromBSONObjectID( bson );
						break;
					
					
					case BSON_BOOLEAN:
						
						arr[count] = fromBSONBoolean( bson );
						break;
					
					
					case BSON_NULL:
						
						arr[count] = null;
						break;
					
					
					case BSON_UTC:
						
						arr[count] = fromBSONDate( bson );
						break;
					
					
					case BSON_BINARY:
						
						arr[count] = fromBSONBinary( bson );
						break;
					
					
					case BSON_INT32:
						
						arr[count] = fromBSONInt32( bson );
						break;
					
					case BSON_INT64:
						
						arr[count] = fromBSONInt64( bson );
						break;
					
					
					default:
						// this should never happen
						trace("fromBSONArray: encountered an unknown object type");
						
				}
				++count;
				type = bson.readByte();
			}
			return arr;
		}
		
		
		/**
		 * @brief Translate a BSON boolean into a Boolean
		 * @param object A BSON boolean
		 * @return A Boolean representing the parameter
		 */
		private static function fromBSONBoolean( bson : ByteArray ) : Boolean {
			return bson.readBoolean();
		}
		
		/**
		 * @brief Translate a BSON document into an Object
		 * @param object A BSON document
		 * @return An Object representing the parameter
		 */
		private static function fromBSONDocument( bson : ByteArray ) : Object {
			var arr : Object = new Object();
			var length : uint = bson.readInt();
			var type : uint = bson.readByte();
			
			while( type != BSON_TERMINATOR ) {
				
				var key : String = readBSONcstring( bson );
				
				switch( type ) {
					
					case BSON_DOUBLE:
						
						arr[key] = fromBSONDouble( bson );
						break;
					
					
					case BSON_STRING:
						
						arr[key] = fromBSONString( bson );
						break;
					
					
					case BSON_DOCUMENT:
						
						arr[key] = fromBSONDocument( bson );
						break;
					
					
					case BSON_ARRAY:
						
						arr[key] = fromBSONArray( bson );
						break;
					
					
					case BSON_OBJECTID:
						
						arr[key] = fromBSONObjectID( bson );
						break;
					
					
					case BSON_BOOLEAN:
						
						arr[key] = fromBSONBoolean( bson );
						break;
					
					
					case BSON_NULL:
						
						arr[key] = null;
						break;
					
					
					case BSON_UTC:
						
						arr[key] = fromBSONDate( bson );
						break;
					
					
					case BSON_BINARY:
						
						arr[key] = fromBSONBinary( bson );
						break;
					
					
					case BSON_INT32:
						
						arr[key] = fromBSONInt32( bson );
						break;
					
				
					case BSON_INT64:
						
						arr[key] = fromBSONInt64( bson );
						break;
					
					
					default:
						// this should never happen
						trace("fromBSONArray: encountered an unknown object type");
						
				}
				type = bson.readByte();
			}	
			return arr;
		}
		
		/**
		 * @brief Translate a BSON int32 into an int
		 * @param object A BSON int32
		 * @return An int representing the parameter
		 */
		private static function fromBSONInt32( bson : ByteArray ) : int {
			return bson.readInt();
		}
		
		/**
		 * @brief Translate a BSON double into a Number
		 * @param object A BSON double
		 * @return A Number representing the parameter
		 */
		private static function fromBSONDouble( bson : ByteArray ) : Number {
			return bson.readDouble();
		}
		
		
		/**
		 * @brief Translate a BSON objectid into an ObjectID
		 * @param object A BSON objectid
		 * @return A String representing the parameter
		 */
		private static function fromBSONObjectID( bson : ByteArray ) : ObjectID {
			return new ObjectID( bson );
		}
		
		/**
		 * @brief Translate a BSON objectid into an Uint64
		 * @param object A BSON uint64
		 * @return A String representing the parameter
		 */
		private static function fromBSONInt64( bson : ByteArray ) : Int64 {
			return new Int64( bson );
		}
		
		
		/**
		 * @brief Translate a BSON string into a String
		 * @param object A BSON string
		 * @return A String representing the parameter
		 */
		private static function fromBSONString( bson : ByteArray ) : String {
			var length : uint = bson.readInt();
			var res : String = bson.readMultiByte(length - 1, "utf-8");
			bson.readByte(); // discard terminator
			return res;
		}
		
		private static function fromBSONDate( bson : ByteArray ) : Date {
			var val : Int64 = new Int64( bson );
			var lowPos : uint = val.getLowPosPart();
			var highPos : uint = val.getHighPosPart();
			var rep : Number = highPos * 4294967296 + lowPos;
			
			if( val.negative() ) {
				rep *= -1;
			}
			
			return new Date( rep );
		}
		
		
		private static function fromBSONBinary( bson : ByteArray ) : Binary {
			var length : int = bson.readInt();
			var subtype : int = bson.readByte();
			// thanks to Михаил
			if( subtype == Binary.BINARY_OLD ) {
				length = bson.readInt();
			}
			var data : ByteArray = new ByteArray();
			bson.readBytes( data, 0, length );
			return new Binary( subtype, data );
		}
		
		
		/**
		 * @brief Translate a BSON cstring into a String
		 * @param object A BSON cstring
		 * @return An String representing the parameter
		 */
		private static function readBSONcstring( bson : ByteArray ) : String {
			var str : String = "";
			var char : uint = bson.readByte();
			while( char != BSON_TERMINATOR ) {
				str += String.fromCharCode( char );
				char = bson.readByte();
			}
			return str;
		}
		
		
		/**
		 * @brief Concatenates two ByteArrays
		 * @param head the first (least significant) array; where the result is stored
		 * @param tail the second (most significant) array
		 */
		private static function joinByteArrays( head : ByteArray, tail : ByteArray ) : void {
			for ( var i : int = 0; i < tail.length; ++i ) {
				head.writeByte(tail[i]);
			}
		}
	}

}