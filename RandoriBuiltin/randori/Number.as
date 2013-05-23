/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is [Open Source Virtual Machine.].
 *
 * The Initial Developer of the Original Code is
 * Adobe System Incorporated.
 * Portions created by the Initial Developer are Copyright (C) 2004-2007
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Adobe AS3 Team
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */


package
{
	// these must match the same constants in MathUtils
	CONFIG const DTOSTR_FIXED = 1
	CONFIG const DTOSTR_PRECISION = 2
	CONFIG const DTOSTR_EXPONENTIAL = 3

	public final class Number 
	{
		// Number.length = 1 per ES3
		// E262 {ReadOnly, DontDelete, DontEnum }
		public static const length:int = 1

		// E262 {DontEnum, DontDelete, ReadOnly}
		public static const NaN               :Number = 0/0
		public static const NEGATIVE_INFINITY :Number = -1/0
		public static const POSITIVE_INFINITY :Number = 1/0
		public static const MIN_VALUE         :Number = 4.9e-324 
		public static const MAX_VALUE         :Number = 1.7976931348623158e+308

		private static native function _toStringRadix(n:Number, radix:int):String
		private static function _toString(n:Number, radix:int):String
		{
		    if (radix == 10 || !isFinite(n))
		        return String(n)
		    if (radix < 2 || radix > 36)
		        throw makeError(RangeError, 1003 /* kInvalidRadixError */, radix)
		    return _toStringRadix(n,radix)
		}
		
		private static native function _convert2(n:Number, precision:int, mode:int):String
		private static function _convert(n:Number, precision:int, mode:int):String
		{
		    var lo:int, hi:int=20
		    
		    if (mode === CONFIG::DTOSTR_PRECISION)
		    {
		        lo++
		        hi++
		    }
	        if (precision < lo || precision > hi)
	            throw makeError(RangeError, 1002 /* kInvalidPrecisionError */, precision, lo, hi)
	        return _convert2(n, precision, mode)
		}

		AS3 function toString(radix=10):String 
		{
			return _toString(this, radix);
		}
		AS3 function valueOf():Number { return this }
		
		CONFIG::Full
		{
		    prototype.toLocaleString = 
		    prototype.toString = function (radix=10):String
		    {
			    if (this === prototype) return "0"
    			
			    if (!(this is Number))
				    throw makeError( TypeError, 1004 /*kInvokeOnIncompatibleObjectError*/, "Number.prototype.toString" );
    				
			    return _toString(this, radix);
		    }

		    prototype.valueOf = function()
		    {
			    if (this === prototype)	return 0
			    if (!(this is Number))
				    throw makeError( TypeError, 1004 /*kInvokeOnIncompatibleObjectError*/, "Number.prototype.valueOf" );
			    return this;
		    }

		    AS3 function toExponential(p=0):String
		    {
			    return _convert(this, p, CONFIG::DTOSTR_EXPONENTIAL)
		    }
		    prototype.toExponential = function(p=0):String
		    {
			    return _convert(this, p, CONFIG::DTOSTR_EXPONENTIAL)
		    }

		    AS3 function toPrecision(p=0):String
		    {
			    if (p == undefined)
				    return this.AS3::toString();

			    return _convert(this, p, CONFIG::DTOSTR_PRECISION)
		    }
		    prototype.toPrecision = function(p=0):String
		    {
			    if (p == undefined)
				    return this.AS3::toString();
    			
			    return _convert(this, p, CONFIG::DTOSTR_PRECISION)
		    }

		    AS3 function toFixed(p=0):String
		    {
			    return _convert(this, p, CONFIG::DTOSTR_FIXED)
		    }
		    prototype.toFixed = function(p=0):String
		    {
			    return _convert(this, p, CONFIG::DTOSTR_FIXED)
		    }
		}

        // Dummy constructor function - This is neccessary so the compiler can do arg # checking for the ctor in strict mode
        // The code for the actual ctor is in NumberClass::construct in the avmplus
        public function Number(value = 0)
        {}

		_hideproto(prototype);
	}

	public final class int
	{
		// based on Number: E262 {ReadOnly, DontDelete, DontEnum}
		public static const MIN_VALUE:int = -0x80000000;
		public static const MAX_VALUE:int =  0x7fffffff;

		// Number.length = 1 per ES3
		// E262 {ReadOnly, DontDelete, DontEnum }
		public static const length:int = 1

		AS3 function toString(radix=10):String 
		{
			return Number(this).AS3::toString(radix)
		}
		AS3 function valueOf():int { return this }

        CONFIG::Full
        {
		    prototype.toLocaleString =
		    prototype.toString = function toString(radix=10):String
		    {
			    if (this === prototype) return "0"
			    if (!(this is int))
				    throw makeError( TypeError, 1004 /*kInvokeOnIncompatibleObjectError*/, "int.prototype.toString" );
			    return Number(this).AS3::toString(radix)
		    }

		    prototype.valueOf = function()
		    {
			    if (this === prototype) return 0
			    if (!(this is int))
				    throw makeError( TypeError, 1004 /*kInvokeOnIncompatibleObjectError*/, "int.prototype.valueOf" );
			    return this
		    }

		    AS3 function toExponential(p=0):String
		    {
			    return Number(this).AS3::toExponential(p)
		    }
		    prototype.toExponential = function(p=0):String
		    {
			    return Number(this).AS3::toExponential(p)
		    }

		    AS3 function toPrecision(p=0):String
		    {
			    return Number(this).AS3::toPrecision(p)
		    }
		    prototype.toPrecision = function(p=0):String
		    {
			    return Number(this).AS3::toPrecision(p)
		    }

		    AS3 function toFixed(p=0):String
		    {
			    return Number(this).AS3::toFixed(p)
		    }
		    prototype.toFixed = function(p=0):String
		    {
			    return Number(this).AS3::toFixed(p)
		    }
		}

        // Dummy constructor function - This is neccessary so the compiler can do arg # checking for the ctor in strict mode
        // The code for the actual ctor is in forth
        public function int(value = 0)
        {}

		_hideproto(prototype);		
	}

	public final class uint
	{
		// based on Number: E262 {ReadOnly, DontDelete, DontEnum}
		public static const MIN_VALUE:uint = 0;
		public static const MAX_VALUE:uint = 0xffffffff;

		// Number.length = 1 per ES3
		// E262 {ReadOnly, DontDelete, DontEnum}
		public static const length:int = 1

		AS3 function toString(radix=10):String 
		{
			return Number(this).AS3::toString(radix)
		}
		AS3 function valueOf():uint { return this }

        CONFIG::Full
        {
		    prototype.toLocaleString =
		    prototype.toString = function toString(radix=10):String
		    {
			    if (this === prototype) return "0"
			    if (!(this is Number))
				    throw makeError( TypeError, 1004 /*kInvokeOnIncompatibleObjectError*/, "uint.prototype.toString" );
			    return Number(this).AS3::toString(radix)
		    }

		    prototype.valueOf = function()
		    {
			    if (this === prototype) return 0
			    if (!(this is uint))
				    throw makeError( TypeError, 1004 /*kInvokeOnIncompatibleObjectError*/, "uint.prototype.valueOf" );
			    return this
		    }

		    AS3 function toExponential(p=0):String
		    {
			    return Number(this).AS3::toExponential(p)
		    }
		    prototype.toExponential = function(p=0):String
		    {
			    return Number(this).AS3::toExponential(p)
		    }

		    AS3 function toPrecision(p=0):String
		    {
			    return Number(this).AS3::toPrecision(p)
		    }
		    prototype.toPrecision = function(p=0):String
		    {
			    return Number(this).AS3::toPrecision(p)
		    }

		    AS3 function toFixed(p=0):String
		    {
			    return Number(this).AS3::toFixed(p)
		    }
		    prototype.toFixed = function(p=0):String
		    {
			    return Number(this).AS3::toFixed(p)
		    }
        }
        
        // Dummy constructor function - This is neccessary so the compiler can do arg # checking for the ctor in strict mode
        // The code for the actual ctor is in forth
        public function uint(value = 0)
        {}

		_hideproto(prototype);
	}
}
