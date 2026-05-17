
//  Microsoft (R) .NET Framework IL Disassembler.  Version 4.0.30319.1
//  Copyright (c) Microsoft Corporation.  All rights reserved.



// Metadata version: v2.0.50727
.assembly extern System.Web
{
  .publickeytoken = (B0 3F 5F 7F 11 D5 0A 3A )                         // .?_....:
  .ver 2:0:0:0
}
.assembly extern mscorlib
{
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 )                         // .z\V.4..
  .ver 2:0:0:0
}
.assembly extern System.Drawing
{
  .publickeytoken = (B0 3F 5F 7F 11 D5 0A 3A )                         // .?_....:
  .ver 2:0:0:0
}
.assembly extern System
{
  .publickeytoken = (B7 7A 5C 56 19 34 E0 89 )                         // .z\V.4..
  .ver 2:0:0:0
}
.assembly MSCaptcha
{
  .custom instance void [mscorlib]System.Reflection.AssemblyDescriptionAttribute::.ctor(string) = ( 01 00 1E 41 53 50 2E 4E 45 54 20 43 41 50 54 43   // ...ASP.NET CAPTC
                                                                                                    48 41 20 73 65 72 76 65 72 20 63 6F 6E 74 72 6F   // HA server contro
                                                                                                    6C 00 00 )                                        // l..
  .custom instance void [mscorlib]System.Reflection.AssemblyTitleAttribute::.ctor(string) = ( 01 00 11 57 65 62 43 6F 6E 74 72 6F 6C 43 61 70   // ...WebControlCap
                                                                                              74 63 68 61 00 00 )                               // tcha..
  .custom instance void [mscorlib]System.Runtime.CompilerServices.CompilationRelaxationsAttribute::.ctor(int32) = ( 01 00 08 00 00 00 00 00 ) 
  .custom instance void [mscorlib]System.Reflection.AssemblyCompanyAttribute::.ctor(string) = ( 01 00 0F 4D 6F 6E 64 6F 72 20 53 6F 66 74 77 61   // ...Mondor Softwa
                                                                                                72 65 00 00 )                                     // re..
  .custom instance void [mscorlib]System.Runtime.CompilerServices.RuntimeCompatibilityAttribute::.ctor() = ( 01 00 01 00 54 02 16 57 72 61 70 4E 6F 6E 45 78   // ....T..WrapNonEx
                                                                                                             63 65 70 74 69 6F 6E 54 68 72 6F 77 73 01 )       // ceptionThrows.
  .custom instance void [mscorlib]System.CLSCompliantAttribute::.ctor(bool) = ( 01 00 01 00 00 ) 
  .custom instance void [mscorlib]System.Reflection.AssemblyCopyrightAttribute::.ctor(string) = ( 01 00 16 C2 A9 32 30 30 37 20 4D 6F 6E 64 6F 72   // .....2007 Mondor
                                                                                                  20 53 6F 66 74 77 61 72 65 00 00 )                //  Software..
  .hash algorithm 0x00008004
  .ver 1:0:2832:11804
}
.mresource public MSCaptcha.CaptchaControl.bmp
{
  // Offset: 0x00000000 Length: 0x00000336
  // WARNING: managed resource file MSCaptcha.CaptchaControl.bmp created
}
.module MSCaptcha.dll
// MVID: {9CD89A5A-A68B-4391-BA6F-6BCFDDA77765}
.imagebase 0x11000000
.file alignment 0x00001000
.stackreserve 0x00100000
.subsystem 0x0003       // WINDOWS_CUI
.corflags 0x00000001    //  ILONLY
// Image base: 0x0000000001F30000


// =============== CLASS MEMBERS DECLARATION ===================

.class public auto ansi beforefieldinit MSCaptcha.CaptchaControl
       extends [System.Web]System.Web.UI.WebControls.WebControl
       implements [System.Web]System.Web.UI.INamingContainer,
                  [System.Web]System.Web.UI.IPostBackDataHandler,
                  [System.Web]System.Web.UI.IValidator
{
  .custom instance void [System]System.ComponentModel.DefaultPropertyAttribute::.ctor(string) = ( 01 00 04 54 65 78 74 00 00 )                      // ...Text..
  .class auto ansi sealed nested public CacheType
         extends [mscorlib]System.Enum
  {
    .field public specialname rtspecialname int32 value__
    .field public static literal valuetype MSCaptcha.CaptchaControl/CacheType HttpRuntime = int32(0x00000000)
    .field public static literal valuetype MSCaptcha.CaptchaControl/CacheType Session = int32(0x00000001)
  } // end of class CacheType

  .field private int32 _timeoutSecondsMax
  .field private int32 _timeoutSecondsMin
  .field private bool _userValidated
  .field private string _text
  .field private string _font
  .field private class MSCaptcha.CaptchaImage _captcha
  .field private string _prevguid
  .field private string _errorMessage
  .field private valuetype MSCaptcha.CaptchaControl/CacheType _cacheStrategy
  .field private string m_ValidationGroup
  .field private string m_CustomValidatorErrorMessage
  .field private valuetype [System.Drawing]System.Drawing.Color _backColor
  .field private valuetype [System.Drawing]System.Drawing.Color _fontColor
  .field private valuetype [System.Drawing]System.Drawing.Color _noiseColor
  .field private valuetype [System.Drawing]System.Drawing.Color _lineColor
  .method public hidebysig specialname instance string 
          get_CustomValidatorErrorMessage() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      string MSCaptcha.CaptchaControl::m_CustomValidatorErrorMessage
    IL_0006:  ret
  } // end of method CaptchaControl::get_CustomValidatorErrorMessage

  .method public hidebysig specialname instance void 
          set_CustomValidatorErrorMessage(string 'value') cil managed
  {
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      string MSCaptcha.CaptchaControl::m_CustomValidatorErrorMessage
    IL_0007:  ret
  } // end of method CaptchaControl::set_CustomValidatorErrorMessage

  .method public hidebysig specialname instance string 
          get_ValidationGroup() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      string MSCaptcha.CaptchaControl::m_ValidationGroup
    IL_0006:  ret
  } // end of method CaptchaControl::get_ValidationGroup

  .method public hidebysig specialname instance void 
          set_ValidationGroup(string 'value') cil managed
  {
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      string MSCaptcha.CaptchaControl::m_ValidationGroup
    IL_0007:  ret
  } // end of method CaptchaControl::set_ValidationGroup

  .method private hidebysig newslot specialname virtual final 
          instance string  System.Web.UI.IValidator.get_ErrorMessage() cil managed
  {
    .override [System.Web]System.Web.UI.IValidator::get_ErrorMessage
    // Code size       21 (0x15)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      bool MSCaptcha.CaptchaControl::_userValidated
    IL_0006:  brtrue.s   IL_000f

    IL_0008:  ldarg.0
    IL_0009:  ldfld      string MSCaptcha.CaptchaControl::_errorMessage
    IL_000e:  ret

    IL_000f:  ldstr      ""
    IL_0014:  ret
  } // end of method CaptchaControl::System.Web.UI.IValidator.get_ErrorMessage

  .method private hidebysig newslot specialname virtual final 
          instance void  System.Web.UI.IValidator.set_ErrorMessage(string 'value') cil managed
  {
    .override [System.Web]System.Web.UI.IValidator::set_ErrorMessage
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      string MSCaptcha.CaptchaControl::_errorMessage
    IL_0007:  ret
  } // end of method CaptchaControl::System.Web.UI.IValidator.set_ErrorMessage

  .method private hidebysig newslot specialname virtual final 
          instance bool  System.Web.UI.IValidator.get_IsValid() cil managed
  {
    .override [System.Web]System.Web.UI.IValidator::get_IsValid
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      bool MSCaptcha.CaptchaControl::_userValidated
    IL_0006:  ret
  } // end of method CaptchaControl::System.Web.UI.IValidator.get_IsValid

  .method private hidebysig newslot specialname virtual final 
          instance void  System.Web.UI.IValidator.set_IsValid(bool 'value') cil managed
  {
    .override [System.Web]System.Web.UI.IValidator::set_IsValid
    // Code size       1 (0x1)
    .maxstack  8
    IL_0000:  ret
  } // end of method CaptchaControl::System.Web.UI.IValidator.set_IsValid

  .method public hidebysig specialname virtual 
          instance bool  get_Enabled() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  call       instance bool [System.Web]System.Web.UI.WebControls.WebControl::get_Enabled()
    IL_0006:  ret
  } // end of method CaptchaControl::get_Enabled

  .method public hidebysig specialname virtual 
          instance void  set_Enabled(bool 'value') cil managed
  {
    // Code size       18 (0x12)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  call       instance void [System.Web]System.Web.UI.WebControls.WebControl::set_Enabled(bool)
    IL_0007:  ldarg.1
    IL_0008:  brtrue.s   IL_0011

    IL_000a:  ldarg.0
    IL_000b:  ldc.i4.1
    IL_000c:  stfld      bool MSCaptcha.CaptchaControl::_userValidated
    IL_0011:  ret
  } // end of method CaptchaControl::set_Enabled

  .method public hidebysig specialname instance valuetype MSCaptcha.CaptchaControl/CacheType 
          get_CacheStrategy() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype MSCaptcha.CaptchaControl/CacheType MSCaptcha.CaptchaControl::_cacheStrategy
    IL_0006:  ret
  } // end of method CaptchaControl::get_CacheStrategy

  .method public hidebysig specialname instance void 
          set_CacheStrategy(valuetype MSCaptcha.CaptchaControl/CacheType 'value') cil managed
  {
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype MSCaptcha.CaptchaControl/CacheType MSCaptcha.CaptchaControl::_cacheStrategy
    IL_0007:  ret
  } // end of method CaptchaControl::set_CacheStrategy

  .method public hidebysig specialname instance bool 
          get_UserValidated() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      bool MSCaptcha.CaptchaControl::_userValidated
    IL_0006:  ret
  } // end of method CaptchaControl::get_UserValidated

  .method public hidebysig specialname instance string 
          get_CaptchaFont() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      string MSCaptcha.CaptchaControl::_font
    IL_0006:  ret
  } // end of method CaptchaControl::get_CaptchaFont

  .method public hidebysig specialname instance void 
          set_CaptchaFont(string 'value') cil managed
  {
    // Code size       25 (0x19)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      string MSCaptcha.CaptchaControl::_font
    IL_0007:  ldarg.0
    IL_0008:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_000d:  ldarg.0
    IL_000e:  ldfld      string MSCaptcha.CaptchaControl::_font
    IL_0013:  callvirt   instance void MSCaptcha.CaptchaImage::set_Font(string)
    IL_0018:  ret
  } // end of method CaptchaControl::set_CaptchaFont

  .method public hidebysig specialname instance string 
          get_CaptchaChars() cil managed
  {
    // Code size       12 (0xc)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  callvirt   instance string MSCaptcha.CaptchaImage::get_TextChars()
    IL_000b:  ret
  } // end of method CaptchaControl::get_CaptchaChars

  .method public hidebysig specialname instance void 
          set_CaptchaChars(string 'value') cil managed
  {
    // Code size       13 (0xd)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  ldarg.1
    IL_0007:  callvirt   instance void MSCaptcha.CaptchaImage::set_TextChars(string)
    IL_000c:  ret
  } // end of method CaptchaControl::set_CaptchaChars

  .method public hidebysig specialname instance int32 
          get_CaptchaLength() cil managed
  {
    // Code size       12 (0xc)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  callvirt   instance int32 MSCaptcha.CaptchaImage::get_TextLength()
    IL_000b:  ret
  } // end of method CaptchaControl::get_CaptchaLength

  .method public hidebysig specialname instance void 
          set_CaptchaLength(int32 'value') cil managed
  {
    // Code size       13 (0xd)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  ldarg.1
    IL_0007:  callvirt   instance void MSCaptcha.CaptchaImage::set_TextLength(int32)
    IL_000c:  ret
  } // end of method CaptchaControl::set_CaptchaLength

  .method public hidebysig specialname instance int32 
          get_CaptchaMinTimeout() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      int32 MSCaptcha.CaptchaControl::_timeoutSecondsMin
    IL_0006:  ret
  } // end of method CaptchaControl::get_CaptchaMinTimeout

  .method public hidebysig specialname instance void 
          set_CaptchaMinTimeout(int32 'value') cil managed
  {
    // Code size       29 (0x1d)
    .maxstack  8
    IL_0000:  ldarg.1
    IL_0001:  ldc.i4.s   15
    IL_0003:  ble.s      IL_0015

    IL_0005:  ldstr      "CaptchaTimeout"
    IL_000a:  ldstr      "Timeout must be less than 15 seconds. Humans aren'"
    + "t that slow!"
    IL_000f:  newobj     instance void [mscorlib]System.ArgumentOutOfRangeException::.ctor(string,
                                                                                           string)
    IL_0014:  throw

    IL_0015:  ldarg.0
    IL_0016:  ldarg.1
    IL_0017:  stfld      int32 MSCaptcha.CaptchaControl::_timeoutSecondsMin
    IL_001c:  ret
  } // end of method CaptchaControl::set_CaptchaMinTimeout

  .method public hidebysig specialname instance int32 
          get_CaptchaMaxTimeout() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      int32 MSCaptcha.CaptchaControl::_timeoutSecondsMax
    IL_0006:  ret
  } // end of method CaptchaControl::get_CaptchaMaxTimeout

  .method public hidebysig specialname instance void 
          set_CaptchaMaxTimeout(int32 'value') cil managed
  {
    // Code size       39 (0x27)
    .maxstack  8
    IL_0000:  ldarg.1
    IL_0001:  ldc.i4.s   15
    IL_0003:  clt
    IL_0005:  ldarg.1
    IL_0006:  ldc.i4.0
    IL_0007:  ceq
    IL_0009:  ldc.i4.0
    IL_000a:  ceq
    IL_000c:  and
    IL_000d:  brfalse.s  IL_001f

    IL_000f:  ldstr      "CaptchaTimeout"
    IL_0014:  ldstr      "Timeout must be greater than 15 seconds. Humans ca"
    + "n't type that fast!"
    IL_0019:  newobj     instance void [mscorlib]System.ArgumentOutOfRangeException::.ctor(string,
                                                                                           string)
    IL_001e:  throw

    IL_001f:  ldarg.0
    IL_0020:  ldarg.1
    IL_0021:  stfld      int32 MSCaptcha.CaptchaControl::_timeoutSecondsMax
    IL_0026:  ret
  } // end of method CaptchaControl::set_CaptchaMaxTimeout

  .method public hidebysig specialname instance int32 
          get_CaptchaHeight() cil managed
  {
    // Code size       12 (0xc)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  callvirt   instance int32 MSCaptcha.CaptchaImage::get_Height()
    IL_000b:  ret
  } // end of method CaptchaControl::get_CaptchaHeight

  .method public hidebysig specialname instance void 
          set_CaptchaHeight(int32 'value') cil managed
  {
    // Code size       13 (0xd)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  ldarg.1
    IL_0007:  callvirt   instance void MSCaptcha.CaptchaImage::set_Height(int32)
    IL_000c:  ret
  } // end of method CaptchaControl::set_CaptchaHeight

  .method public hidebysig specialname instance int32 
          get_CaptchaWidth() cil managed
  {
    // Code size       12 (0xc)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  callvirt   instance int32 MSCaptcha.CaptchaImage::get_Width()
    IL_000b:  ret
  } // end of method CaptchaControl::get_CaptchaWidth

  .method public hidebysig specialname instance void 
          set_CaptchaWidth(int32 'value') cil managed
  {
    // Code size       13 (0xd)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  ldarg.1
    IL_0007:  callvirt   instance void MSCaptcha.CaptchaImage::set_Width(int32)
    IL_000c:  ret
  } // end of method CaptchaControl::set_CaptchaWidth

  .method public hidebysig specialname instance valuetype MSCaptcha.CaptchaImage/FontWarpFactor 
          get_CaptchaFontWarping() cil managed
  {
    // Code size       12 (0xc)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  callvirt   instance valuetype MSCaptcha.CaptchaImage/FontWarpFactor MSCaptcha.CaptchaImage::get_FontWarp()
    IL_000b:  ret
  } // end of method CaptchaControl::get_CaptchaFontWarping

  .method public hidebysig specialname instance void 
          set_CaptchaFontWarping(valuetype MSCaptcha.CaptchaImage/FontWarpFactor 'value') cil managed
  {
    // Code size       13 (0xd)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  ldarg.1
    IL_0007:  callvirt   instance void MSCaptcha.CaptchaImage::set_FontWarp(valuetype MSCaptcha.CaptchaImage/FontWarpFactor)
    IL_000c:  ret
  } // end of method CaptchaControl::set_CaptchaFontWarping

  .method public hidebysig specialname instance valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel 
          get_CaptchaBackgroundNoise() cil managed
  {
    // Code size       12 (0xc)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  callvirt   instance valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel MSCaptcha.CaptchaImage::get_BackgroundNoise()
    IL_000b:  ret
  } // end of method CaptchaControl::get_CaptchaBackgroundNoise

  .method public hidebysig specialname instance void 
          set_CaptchaBackgroundNoise(valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel 'value') cil managed
  {
    // Code size       13 (0xd)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  ldarg.1
    IL_0007:  callvirt   instance void MSCaptcha.CaptchaImage::set_BackgroundNoise(valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel)
    IL_000c:  ret
  } // end of method CaptchaControl::set_CaptchaBackgroundNoise

  .method public hidebysig specialname instance valuetype MSCaptcha.CaptchaImage/LineNoiseLevel 
          get_CaptchaLineNoise() cil managed
  {
    // Code size       12 (0xc)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  callvirt   instance valuetype MSCaptcha.CaptchaImage/LineNoiseLevel MSCaptcha.CaptchaImage::get_LineNoise()
    IL_000b:  ret
  } // end of method CaptchaControl::get_CaptchaLineNoise

  .method public hidebysig specialname instance void 
          set_CaptchaLineNoise(valuetype MSCaptcha.CaptchaImage/LineNoiseLevel 'value') cil managed
  {
    // Code size       13 (0xd)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  ldarg.1
    IL_0007:  callvirt   instance void MSCaptcha.CaptchaImage::set_LineNoise(valuetype MSCaptcha.CaptchaImage/LineNoiseLevel)
    IL_000c:  ret
  } // end of method CaptchaControl::set_CaptchaLineNoise

  .method public hidebysig specialname instance valuetype [System.Drawing]System.Drawing.Color 
          get_BackColor() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_backColor
    IL_0006:  ret
  } // end of method CaptchaControl::get_BackColor

  .method public hidebysig specialname instance void 
          set_BackColor(valuetype [System.Drawing]System.Drawing.Color 'value') cil managed
  {
    // Code size       25 (0x19)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_backColor
    IL_0007:  ldarg.0
    IL_0008:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_000d:  ldarg.0
    IL_000e:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_backColor
    IL_0013:  callvirt   instance void MSCaptcha.CaptchaImage::set_BackColor(valuetype [System.Drawing]System.Drawing.Color)
    IL_0018:  ret
  } // end of method CaptchaControl::set_BackColor

  .method public hidebysig specialname instance valuetype [System.Drawing]System.Drawing.Color 
          get_FontColor() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_fontColor
    IL_0006:  ret
  } // end of method CaptchaControl::get_FontColor

  .method public hidebysig specialname instance void 
          set_FontColor(valuetype [System.Drawing]System.Drawing.Color 'value') cil managed
  {
    // Code size       25 (0x19)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_fontColor
    IL_0007:  ldarg.0
    IL_0008:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_000d:  ldarg.0
    IL_000e:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_fontColor
    IL_0013:  callvirt   instance void MSCaptcha.CaptchaImage::set_FontColor(valuetype [System.Drawing]System.Drawing.Color)
    IL_0018:  ret
  } // end of method CaptchaControl::set_FontColor

  .method public hidebysig specialname instance valuetype [System.Drawing]System.Drawing.Color 
          get_NoiseColor() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_noiseColor
    IL_0006:  ret
  } // end of method CaptchaControl::get_NoiseColor

  .method public hidebysig specialname instance void 
          set_NoiseColor(valuetype [System.Drawing]System.Drawing.Color 'value') cil managed
  {
    // Code size       25 (0x19)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_noiseColor
    IL_0007:  ldarg.0
    IL_0008:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_000d:  ldarg.0
    IL_000e:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_noiseColor
    IL_0013:  callvirt   instance void MSCaptcha.CaptchaImage::set_NoiseColor(valuetype [System.Drawing]System.Drawing.Color)
    IL_0018:  ret
  } // end of method CaptchaControl::set_NoiseColor

  .method public hidebysig specialname instance valuetype [System.Drawing]System.Drawing.Color 
          get_LineColor() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_lineColor
    IL_0006:  ret
  } // end of method CaptchaControl::get_LineColor

  .method public hidebysig specialname instance void 
          set_LineColor(valuetype [System.Drawing]System.Drawing.Color 'value') cil managed
  {
    // Code size       25 (0x19)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_lineColor
    IL_0007:  ldarg.0
    IL_0008:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_000d:  ldarg.0
    IL_000e:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_lineColor
    IL_0013:  callvirt   instance void MSCaptcha.CaptchaImage::set_LineColor(valuetype [System.Drawing]System.Drawing.Color)
    IL_0018:  ret
  } // end of method CaptchaControl::set_LineColor

  .method private hidebysig newslot virtual final 
          instance void  System.Web.UI.IValidator.Validate() cil managed
  {
    .override [System.Web]System.Web.UI.IValidator::Validate
    // Code size       1 (0x1)
    .maxstack  8
    IL_0000:  ret
  } // end of method CaptchaControl::System.Web.UI.IValidator.Validate

  .method private hidebysig instance class MSCaptcha.CaptchaImage 
          GetCachedCaptcha(string guid) cil managed
  {
    // Code size       47 (0x2f)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype MSCaptcha.CaptchaControl/CacheType MSCaptcha.CaptchaControl::_cacheStrategy
    IL_0006:  brtrue.s   IL_0019

    IL_0008:  call       class [System.Web]System.Web.Caching.Cache [System.Web]System.Web.HttpRuntime::get_Cache()
    IL_000d:  ldarg.1
    IL_000e:  callvirt   instance object [System.Web]System.Web.Caching.Cache::Get(string)
    IL_0013:  castclass  MSCaptcha.CaptchaImage
    IL_0018:  ret

    IL_0019:  call       class [System.Web]System.Web.HttpContext [System.Web]System.Web.HttpContext::get_Current()
    IL_001e:  callvirt   instance class [System.Web]System.Web.SessionState.HttpSessionState [System.Web]System.Web.HttpContext::get_Session()
    IL_0023:  ldarg.1
    IL_0024:  callvirt   instance object [System.Web]System.Web.SessionState.HttpSessionState::get_Item(string)
    IL_0029:  castclass  MSCaptcha.CaptchaImage
    IL_002e:  ret
  } // end of method CaptchaControl::GetCachedCaptcha

  .method private hidebysig instance void 
          RemoveCachedCaptcha(string guid) cil managed
  {
    // Code size       38 (0x26)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype MSCaptcha.CaptchaControl/CacheType MSCaptcha.CaptchaControl::_cacheStrategy
    IL_0006:  brtrue.s   IL_0015

    IL_0008:  call       class [System.Web]System.Web.Caching.Cache [System.Web]System.Web.HttpRuntime::get_Cache()
    IL_000d:  ldarg.1
    IL_000e:  callvirt   instance object [System.Web]System.Web.Caching.Cache::Remove(string)
    IL_0013:  pop
    IL_0014:  ret

    IL_0015:  call       class [System.Web]System.Web.HttpContext [System.Web]System.Web.HttpContext::get_Current()
    IL_001a:  callvirt   instance class [System.Web]System.Web.SessionState.HttpSessionState [System.Web]System.Web.HttpContext::get_Session()
    IL_001f:  ldarg.1
    IL_0020:  callvirt   instance void [System.Web]System.Web.SessionState.HttpSessionState::Remove(string)
    IL_0025:  ret
  } // end of method CaptchaControl::RemoveCachedCaptcha

  .method private hidebysig specialname instance bool 
          get_IsDesignMode() cil managed
  {
    // Code size       9 (0x9)
    .maxstack  8
    IL_0000:  call       class [System.Web]System.Web.HttpContext [System.Web]System.Web.HttpContext::get_Current()
    IL_0005:  ldnull
    IL_0006:  ceq
    IL_0008:  ret
  } // end of method CaptchaControl::get_IsDesignMode

  .method public hidebysig instance void 
          ValidateCaptcha(string userEntry) cil managed
  {
    // Code size       245 (0xf5)
    .maxstack  4
    .locals init (class MSCaptcha.CaptchaImage V_0,
             valuetype [mscorlib]System.DateTime V_1)
    IL_0000:  ldarg.0
    IL_0001:  callvirt   instance bool [System.Web]System.Web.UI.Control::get_Visible()
    IL_0006:  ldc.i4.0
    IL_0007:  ceq
    IL_0009:  ldarg.0
    IL_000a:  callvirt   instance bool [System.Web]System.Web.UI.WebControls.WebControl::get_Enabled()
    IL_000f:  ldc.i4.0
    IL_0010:  ceq
    IL_0012:  or
    IL_0013:  brfalse.s  IL_001d

    IL_0015:  ldarg.0
    IL_0016:  ldc.i4.1
    IL_0017:  stfld      bool MSCaptcha.CaptchaControl::_userValidated
    IL_001c:  ret

    IL_001d:  ldarg.0
    IL_001e:  ldarg.0
    IL_001f:  ldfld      string MSCaptcha.CaptchaControl::_prevguid
    IL_0024:  call       instance class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::GetCachedCaptcha(string)
    IL_0029:  stloc.0
    IL_002a:  ldloc.0
    IL_002b:  brtrue.s   IL_0055

    IL_002d:  ldarg.0
    IL_002e:  ldstr      "The code you typed has expired after "
    IL_0033:  ldarg.0
    IL_0034:  call       instance int32 MSCaptcha.CaptchaControl::get_CaptchaMaxTimeout()
    IL_0039:  box        [mscorlib]System.Int32
    IL_003e:  ldstr      " seconds."
    IL_0043:  call       string [mscorlib]System.String::Concat(object,
                                                                object,
                                                                object)
    IL_0048:  callvirt   instance void [System.Web]System.Web.UI.IValidator::set_ErrorMessage(string)
    IL_004d:  ldarg.0
    IL_004e:  ldc.i4.0
    IL_004f:  stfld      bool MSCaptcha.CaptchaControl::_userValidated
    IL_0054:  ret

    IL_0055:  ldarg.0
    IL_0056:  call       instance int32 MSCaptcha.CaptchaControl::get_CaptchaMinTimeout()
    IL_005b:  ldc.i4.0
    IL_005c:  ble.s      IL_00b3

    IL_005e:  ldloc.0
    IL_005f:  callvirt   instance valuetype [mscorlib]System.DateTime MSCaptcha.CaptchaImage::get_RenderedAt()
    IL_0064:  stloc.1
    IL_0065:  ldloca.s   V_1
    IL_0067:  ldarg.0
    IL_0068:  call       instance int32 MSCaptcha.CaptchaControl::get_CaptchaMinTimeout()
    IL_006d:  conv.r8
    IL_006e:  call       instance valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::AddSeconds(float64)
    IL_0073:  call       valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::get_Now()
    IL_0078:  call       bool [mscorlib]System.DateTime::op_GreaterThan(valuetype [mscorlib]System.DateTime,
                                                                        valuetype [mscorlib]System.DateTime)
    IL_007d:  brfalse.s  IL_00b3

    IL_007f:  ldarg.0
    IL_0080:  ldc.i4.0
    IL_0081:  stfld      bool MSCaptcha.CaptchaControl::_userValidated
    IL_0086:  ldarg.0
    IL_0087:  ldstr      "Code was typed too quickly. Wait at least "
    IL_008c:  ldarg.0
    IL_008d:  call       instance int32 MSCaptcha.CaptchaControl::get_CaptchaMinTimeout()
    IL_0092:  box        [mscorlib]System.Int32
    IL_0097:  ldstr      " seconds."
    IL_009c:  call       string [mscorlib]System.String::Concat(object,
                                                                object,
                                                                object)
    IL_00a1:  callvirt   instance void [System.Web]System.Web.UI.IValidator::set_ErrorMessage(string)
    IL_00a6:  ldarg.0
    IL_00a7:  ldarg.0
    IL_00a8:  ldfld      string MSCaptcha.CaptchaControl::_prevguid
    IL_00ad:  call       instance void MSCaptcha.CaptchaControl::RemoveCachedCaptcha(string)
    IL_00b2:  ret

    IL_00b3:  ldarg.1
    IL_00b4:  ldloc.0
    IL_00b5:  callvirt   instance string MSCaptcha.CaptchaImage::get_Text()
    IL_00ba:  ldc.i4.1
    IL_00bb:  call       int32 [mscorlib]System.String::Compare(string,
                                                                string,
                                                                bool)
    IL_00c0:  brfalse.s  IL_00e1

    IL_00c2:  ldarg.0
    IL_00c3:  ldstr      "The code you typed does not match the code in the "
    + "image."
    IL_00c8:  callvirt   instance void [System.Web]System.Web.UI.IValidator::set_ErrorMessage(string)
    IL_00cd:  ldarg.0
    IL_00ce:  ldc.i4.0
    IL_00cf:  stfld      bool MSCaptcha.CaptchaControl::_userValidated
    IL_00d4:  ldarg.0
    IL_00d5:  ldarg.0
    IL_00d6:  ldfld      string MSCaptcha.CaptchaControl::_prevguid
    IL_00db:  call       instance void MSCaptcha.CaptchaControl::RemoveCachedCaptcha(string)
    IL_00e0:  ret

    IL_00e1:  ldarg.0
    IL_00e2:  ldc.i4.1
    IL_00e3:  stfld      bool MSCaptcha.CaptchaControl::_userValidated
    IL_00e8:  ldarg.0
    IL_00e9:  ldarg.0
    IL_00ea:  ldfld      string MSCaptcha.CaptchaControl::_prevguid
    IL_00ef:  call       instance void MSCaptcha.CaptchaControl::RemoveCachedCaptcha(string)
    IL_00f4:  ret
  } // end of method CaptchaControl::ValidateCaptcha

  .method private hidebysig instance string 
          HtmlColor(valuetype [System.Drawing]System.Drawing.Color color) cil managed
  {
    // Code size       102 (0x66)
    .maxstack  3
    .locals init (int32 V_0)
    IL_0000:  ldarga.s   color
    IL_0002:  call       instance bool [System.Drawing]System.Drawing.Color::get_IsEmpty()
    IL_0007:  brfalse.s  IL_000f

    IL_0009:  ldstr      ""
    IL_000e:  ret

    IL_000f:  ldarga.s   color
    IL_0011:  call       instance bool [System.Drawing]System.Drawing.Color::get_IsNamedColor()
    IL_0016:  brfalse.s  IL_002a

    IL_0018:  ldarga.s   color
    IL_001a:  call       instance valuetype [System.Drawing]System.Drawing.KnownColor [System.Drawing]System.Drawing.Color::ToKnownColor()
    IL_001f:  box        [System.Drawing]System.Drawing.KnownColor
    IL_0024:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_0029:  ret

    IL_002a:  ldarga.s   color
    IL_002c:  call       instance bool [System.Drawing]System.Drawing.Color::get_IsSystemColor()
    IL_0031:  brfalse.s  IL_0041

    IL_0033:  ldarga.s   color
    IL_0035:  constrained. [System.Drawing]System.Drawing.Color
    IL_003b:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_0040:  ret

    IL_0041:  ldstr      "#"
    IL_0046:  ldarga.s   color
    IL_0048:  call       instance int32 [System.Drawing]System.Drawing.Color::ToArgb()
    IL_004d:  stloc.0
    IL_004e:  ldloca.s   V_0
    IL_0050:  ldstr      "x"
    IL_0055:  call       instance string [mscorlib]System.Int32::ToString(string)
    IL_005a:  ldc.i4.2
    IL_005b:  callvirt   instance string [mscorlib]System.String::Substring(int32)
    IL_0060:  call       string [mscorlib]System.String::Concat(string,
                                                                string)
    IL_0065:  ret
  } // end of method CaptchaControl::HtmlColor

  .method private hidebysig instance string 
          CssStyle() cil managed
  {
    // Code size       811 (0x32b)
    .maxstack  4
    .locals init (class [mscorlib]System.Text.StringBuilder V_0,
             string V_1,
             string V_2,
             valuetype [System.Web]System.Web.UI.WebControls.Unit V_3,
             valuetype [System.Web]System.Web.UI.WebControls.Unit V_4,
             valuetype [System.Web]System.Web.UI.WebControls.FontUnit V_5,
             valuetype [System.Web]System.Web.UI.WebControls.FontUnit V_6,
             string[] V_7,
             int32 V_8,
             valuetype [System.Web]System.Web.UI.WebControls.Unit V_9,
             valuetype [System.Web]System.Web.UI.WebControls.Unit V_10,
             valuetype [System.Web]System.Web.UI.WebControls.Unit V_11,
             valuetype [System.Web]System.Web.UI.WebControls.Unit V_12)
    IL_0000:  newobj     instance void [mscorlib]System.Text.StringBuilder::.ctor()
    IL_0005:  stloc.0
    IL_0006:  ldloc.0
    IL_0007:  ldstr      " style='"
    IL_000c:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0011:  pop
    IL_0012:  ldarg.0
    IL_0013:  callvirt   instance valuetype [System.Web]System.Web.UI.WebControls.Unit [System.Web]System.Web.UI.WebControls.WebControl::get_BorderWidth()
    IL_0018:  stloc.3
    IL_0019:  ldloca.s   V_3
    IL_001b:  constrained. [System.Web]System.Web.UI.WebControls.Unit
    IL_0021:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_0026:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_002b:  ldc.i4.0
    IL_002c:  ble.s      IL_0062

    IL_002e:  ldloc.0
    IL_002f:  ldstr      "border-width:"
    IL_0034:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0039:  pop
    IL_003a:  ldloc.0
    IL_003b:  ldarg.0
    IL_003c:  callvirt   instance valuetype [System.Web]System.Web.UI.WebControls.Unit [System.Web]System.Web.UI.WebControls.WebControl::get_BorderWidth()
    IL_0041:  stloc.s    V_4
    IL_0043:  ldloca.s   V_4
    IL_0045:  constrained. [System.Web]System.Web.UI.WebControls.Unit
    IL_004b:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_0050:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0055:  pop
    IL_0056:  ldloc.0
    IL_0057:  ldstr      ";"
    IL_005c:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0061:  pop
    IL_0062:  ldarg.0
    IL_0063:  callvirt   instance valuetype [System.Web]System.Web.UI.WebControls.BorderStyle [System.Web]System.Web.UI.WebControls.WebControl::get_BorderStyle()
    IL_0068:  brfalse.s  IL_0099

    IL_006a:  ldloc.0
    IL_006b:  ldstr      "border-style:"
    IL_0070:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0075:  pop
    IL_0076:  ldloc.0
    IL_0077:  ldarg.0
    IL_0078:  callvirt   instance valuetype [System.Web]System.Web.UI.WebControls.BorderStyle [System.Web]System.Web.UI.WebControls.WebControl::get_BorderStyle()
    IL_007d:  box        [System.Web]System.Web.UI.WebControls.BorderStyle
    IL_0082:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_0087:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_008c:  pop
    IL_008d:  ldloc.0
    IL_008e:  ldstr      ";"
    IL_0093:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0098:  pop
    IL_0099:  ldarg.0
    IL_009a:  ldarg.0
    IL_009b:  callvirt   instance valuetype [System.Drawing]System.Drawing.Color [System.Web]System.Web.UI.WebControls.WebControl::get_BorderColor()
    IL_00a0:  call       instance string MSCaptcha.CaptchaControl::HtmlColor(valuetype [System.Drawing]System.Drawing.Color)
    IL_00a5:  stloc.1
    IL_00a6:  ldloc.1
    IL_00a7:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_00ac:  ldc.i4.0
    IL_00ad:  ble.s      IL_00cf

    IL_00af:  ldloc.0
    IL_00b0:  ldstr      "border-color:"
    IL_00b5:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_00ba:  pop
    IL_00bb:  ldloc.0
    IL_00bc:  ldloc.1
    IL_00bd:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_00c2:  pop
    IL_00c3:  ldloc.0
    IL_00c4:  ldstr      ";"
    IL_00c9:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_00ce:  pop
    IL_00cf:  ldarg.0
    IL_00d0:  ldarg.0
    IL_00d1:  call       instance valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::get_BackColor()
    IL_00d6:  call       instance string MSCaptcha.CaptchaControl::HtmlColor(valuetype [System.Drawing]System.Drawing.Color)
    IL_00db:  stloc.1
    IL_00dc:  ldloc.1
    IL_00dd:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_00e2:  ldc.i4.0
    IL_00e3:  ble.s      IL_00fc

    IL_00e5:  ldloc.0
    IL_00e6:  ldstr      "background-color:"
    IL_00eb:  ldloc.1
    IL_00ec:  ldstr      ";"
    IL_00f1:  call       string [mscorlib]System.String::Concat(string,
                                                                string,
                                                                string)
    IL_00f6:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_00fb:  pop
    IL_00fc:  ldarg.0
    IL_00fd:  ldarg.0
    IL_00fe:  callvirt   instance valuetype [System.Drawing]System.Drawing.Color [System.Web]System.Web.UI.WebControls.WebControl::get_ForeColor()
    IL_0103:  call       instance string MSCaptcha.CaptchaControl::HtmlColor(valuetype [System.Drawing]System.Drawing.Color)
    IL_0108:  stloc.1
    IL_0109:  ldloc.1
    IL_010a:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_010f:  ldc.i4.0
    IL_0110:  ble.s      IL_0129

    IL_0112:  ldloc.0
    IL_0113:  ldstr      "color:"
    IL_0118:  ldloc.1
    IL_0119:  ldstr      ";"
    IL_011e:  call       string [mscorlib]System.String::Concat(string,
                                                                string,
                                                                string)
    IL_0123:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0128:  pop
    IL_0129:  ldarg.0
    IL_012a:  callvirt   instance class [System.Web]System.Web.UI.WebControls.FontInfo [System.Web]System.Web.UI.WebControls.WebControl::get_Font()
    IL_012f:  callvirt   instance bool [System.Web]System.Web.UI.WebControls.FontInfo::get_Bold()
    IL_0134:  brfalse.s  IL_0142

    IL_0136:  ldloc.0
    IL_0137:  ldstr      "font-weight:bold;"
    IL_013c:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0141:  pop
    IL_0142:  ldarg.0
    IL_0143:  callvirt   instance class [System.Web]System.Web.UI.WebControls.FontInfo [System.Web]System.Web.UI.WebControls.WebControl::get_Font()
    IL_0148:  callvirt   instance bool [System.Web]System.Web.UI.WebControls.FontInfo::get_Italic()
    IL_014d:  brfalse.s  IL_015b

    IL_014f:  ldloc.0
    IL_0150:  ldstr      "font-style:italic;"
    IL_0155:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_015a:  pop
    IL_015b:  ldarg.0
    IL_015c:  callvirt   instance class [System.Web]System.Web.UI.WebControls.FontInfo [System.Web]System.Web.UI.WebControls.WebControl::get_Font()
    IL_0161:  callvirt   instance bool [System.Web]System.Web.UI.WebControls.FontInfo::get_Underline()
    IL_0166:  brfalse.s  IL_0174

    IL_0168:  ldloc.0
    IL_0169:  ldstr      "text-decoration:underline;"
    IL_016e:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0173:  pop
    IL_0174:  ldarg.0
    IL_0175:  callvirt   instance class [System.Web]System.Web.UI.WebControls.FontInfo [System.Web]System.Web.UI.WebControls.WebControl::get_Font()
    IL_017a:  callvirt   instance bool [System.Web]System.Web.UI.WebControls.FontInfo::get_Strikeout()
    IL_017f:  brfalse.s  IL_018d

    IL_0181:  ldloc.0
    IL_0182:  ldstr      "text-decoration:line-through;"
    IL_0187:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_018c:  pop
    IL_018d:  ldarg.0
    IL_018e:  callvirt   instance class [System.Web]System.Web.UI.WebControls.FontInfo [System.Web]System.Web.UI.WebControls.WebControl::get_Font()
    IL_0193:  callvirt   instance bool [System.Web]System.Web.UI.WebControls.FontInfo::get_Overline()
    IL_0198:  brfalse.s  IL_01a6

    IL_019a:  ldloc.0
    IL_019b:  ldstr      "text-decoration:overline;"
    IL_01a0:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_01a5:  pop
    IL_01a6:  ldarg.0
    IL_01a7:  callvirt   instance class [System.Web]System.Web.UI.WebControls.FontInfo [System.Web]System.Web.UI.WebControls.WebControl::get_Font()
    IL_01ac:  callvirt   instance valuetype [System.Web]System.Web.UI.WebControls.FontUnit [System.Web]System.Web.UI.WebControls.FontInfo::get_Size()
    IL_01b1:  stloc.s    V_5
    IL_01b3:  ldloca.s   V_5
    IL_01b5:  constrained. [System.Web]System.Web.UI.WebControls.FontUnit
    IL_01bb:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_01c0:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_01c5:  ldc.i4.0
    IL_01c6:  ble.s      IL_01f8

    IL_01c8:  ldloc.0
    IL_01c9:  ldstr      "font-size:"
    IL_01ce:  ldarg.0
    IL_01cf:  callvirt   instance class [System.Web]System.Web.UI.WebControls.FontInfo [System.Web]System.Web.UI.WebControls.WebControl::get_Font()
    IL_01d4:  callvirt   instance valuetype [System.Web]System.Web.UI.WebControls.FontUnit [System.Web]System.Web.UI.WebControls.FontInfo::get_Size()
    IL_01d9:  stloc.s    V_6
    IL_01db:  ldloca.s   V_6
    IL_01dd:  constrained. [System.Web]System.Web.UI.WebControls.FontUnit
    IL_01e3:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_01e8:  ldstr      ";"
    IL_01ed:  call       string [mscorlib]System.String::Concat(string,
                                                                string,
                                                                string)
    IL_01f2:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_01f7:  pop
    IL_01f8:  ldarg.0
    IL_01f9:  callvirt   instance class [System.Web]System.Web.UI.WebControls.FontInfo [System.Web]System.Web.UI.WebControls.WebControl::get_Font()
    IL_01fe:  callvirt   instance string[] [System.Web]System.Web.UI.WebControls.FontInfo::get_Names()
    IL_0203:  ldlen
    IL_0204:  conv.i4
    IL_0205:  ldc.i4.0
    IL_0206:  ble.s      IL_0268

    IL_0208:  ldloc.0
    IL_0209:  ldstr      "font-family:"
    IL_020e:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0213:  pop
    IL_0214:  ldarg.0
    IL_0215:  callvirt   instance class [System.Web]System.Web.UI.WebControls.FontInfo [System.Web]System.Web.UI.WebControls.WebControl::get_Font()
    IL_021a:  callvirt   instance string[] [System.Web]System.Web.UI.WebControls.FontInfo::get_Names()
    IL_021f:  stloc.s    V_7
    IL_0221:  ldc.i4.0
    IL_0222:  stloc.s    V_8
    IL_0224:  br.s       IL_0246

    IL_0226:  ldloc.s    V_7
    IL_0228:  ldloc.s    V_8
    IL_022a:  ldelem.ref
    IL_022b:  stloc.2
    IL_022c:  ldloc.0
    IL_022d:  ldloc.2
    IL_022e:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0233:  pop
    IL_0234:  ldloc.0
    IL_0235:  ldstr      ","
    IL_023a:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_023f:  pop
    IL_0240:  ldloc.s    V_8
    IL_0242:  ldc.i4.1
    IL_0243:  add
    IL_0244:  stloc.s    V_8
    IL_0246:  ldloc.s    V_8
    IL_0248:  ldloc.s    V_7
    IL_024a:  ldlen
    IL_024b:  conv.i4
    IL_024c:  blt.s      IL_0226

    IL_024e:  ldloc.0
    IL_024f:  ldloc.0
    IL_0250:  callvirt   instance int32 [mscorlib]System.Text.StringBuilder::get_Length()
    IL_0255:  ldc.i4.1
    IL_0256:  sub
    IL_0257:  callvirt   instance void [mscorlib]System.Text.StringBuilder::set_Length(int32)
    IL_025c:  ldloc.0
    IL_025d:  ldstr      ";"
    IL_0262:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_0267:  pop
    IL_0268:  ldarg.0
    IL_0269:  callvirt   instance valuetype [System.Web]System.Web.UI.WebControls.Unit [System.Web]System.Web.UI.WebControls.WebControl::get_Height()
    IL_026e:  stloc.s    V_9
    IL_0270:  ldloca.s   V_9
    IL_0272:  constrained. [System.Web]System.Web.UI.WebControls.Unit
    IL_0278:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_027d:  ldstr      ""
    IL_0282:  call       bool [mscorlib]System.String::op_Inequality(string,
                                                                     string)
    IL_0287:  brfalse.s  IL_02b4

    IL_0289:  ldloc.0
    IL_028a:  ldstr      "height:"
    IL_028f:  ldarg.0
    IL_0290:  callvirt   instance valuetype [System.Web]System.Web.UI.WebControls.Unit [System.Web]System.Web.UI.WebControls.WebControl::get_Height()
    IL_0295:  stloc.s    V_10
    IL_0297:  ldloca.s   V_10
    IL_0299:  constrained. [System.Web]System.Web.UI.WebControls.Unit
    IL_029f:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_02a4:  ldstr      ";"
    IL_02a9:  call       string [mscorlib]System.String::Concat(string,
                                                                string,
                                                                string)
    IL_02ae:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_02b3:  pop
    IL_02b4:  ldarg.0
    IL_02b5:  callvirt   instance valuetype [System.Web]System.Web.UI.WebControls.Unit [System.Web]System.Web.UI.WebControls.WebControl::get_Width()
    IL_02ba:  stloc.s    V_11
    IL_02bc:  ldloca.s   V_11
    IL_02be:  constrained. [System.Web]System.Web.UI.WebControls.Unit
    IL_02c4:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_02c9:  ldstr      ""
    IL_02ce:  call       bool [mscorlib]System.String::op_Inequality(string,
                                                                     string)
    IL_02d3:  brfalse.s  IL_0300

    IL_02d5:  ldloc.0
    IL_02d6:  ldstr      "width:"
    IL_02db:  ldarg.0
    IL_02dc:  callvirt   instance valuetype [System.Web]System.Web.UI.WebControls.Unit [System.Web]System.Web.UI.WebControls.WebControl::get_Width()
    IL_02e1:  stloc.s    V_12
    IL_02e3:  ldloca.s   V_12
    IL_02e5:  constrained. [System.Web]System.Web.UI.WebControls.Unit
    IL_02eb:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_02f0:  ldstr      ";"
    IL_02f5:  call       string [mscorlib]System.String::Concat(string,
                                                                string,
                                                                string)
    IL_02fa:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_02ff:  pop
    IL_0300:  ldloc.0
    IL_0301:  ldstr      "'"
    IL_0306:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_030b:  pop
    IL_030c:  ldloc.0
    IL_030d:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_0312:  ldstr      " style=''"
    IL_0317:  call       bool [mscorlib]System.String::op_Equality(string,
                                                                   string)
    IL_031c:  brfalse.s  IL_0324

    IL_031e:  ldstr      ""
    IL_0323:  ret

    IL_0324:  ldloc.0
    IL_0325:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_032a:  ret
  } // end of method CaptchaControl::CssStyle

  .method family hidebysig virtual instance void 
          Render(class [System.Web]System.Web.UI.HtmlTextWriter Output) cil managed
  {
    // Code size       289 (0x121)
    .maxstack  4
    IL_0000:  ldarg.1
    IL_0001:  ldstr      "<div"
    IL_0006:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_000b:  ldarg.0
    IL_000c:  callvirt   instance string [System.Web]System.Web.UI.WebControls.WebControl::get_CssClass()
    IL_0011:  ldstr      ""
    IL_0016:  call       bool [mscorlib]System.String::op_Inequality(string,
                                                                     string)
    IL_001b:  brfalse.s  IL_0038

    IL_001d:  ldarg.1
    IL_001e:  ldstr      " class='"
    IL_0023:  ldarg.0
    IL_0024:  callvirt   instance string [System.Web]System.Web.UI.WebControls.WebControl::get_CssClass()
    IL_0029:  ldstr      "'"
    IL_002e:  call       string [mscorlib]System.String::Concat(string,
                                                                string,
                                                                string)
    IL_0033:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_0038:  ldarg.1
    IL_0039:  ldarg.0
    IL_003a:  call       instance string MSCaptcha.CaptchaControl::CssStyle()
    IL_003f:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_0044:  ldarg.1
    IL_0045:  ldstr      ">"
    IL_004a:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_004f:  ldarg.1
    IL_0050:  ldstr      "<img src=\"CaptchaImage.axd"
    IL_0055:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_005a:  ldarg.0
    IL_005b:  call       instance bool MSCaptcha.CaptchaControl::get_IsDesignMode()
    IL_0060:  brtrue.s   IL_0082

    IL_0062:  ldarg.1
    IL_0063:  ldstr      "\?guid="
    IL_0068:  ldarg.0
    IL_0069:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_006e:  callvirt   instance string MSCaptcha.CaptchaImage::get_UniqueId()
    IL_0073:  call       string [mscorlib]System.Convert::ToString(string)
    IL_0078:  call       string [mscorlib]System.String::Concat(string,
                                                                string)
    IL_007d:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_0082:  ldarg.0
    IL_0083:  call       instance valuetype MSCaptcha.CaptchaControl/CacheType MSCaptcha.CaptchaControl::get_CacheStrategy()
    IL_0088:  ldc.i4.1
    IL_0089:  bne.un.s   IL_0096

    IL_008b:  ldarg.1
    IL_008c:  ldstr      "&s=1"
    IL_0091:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_0096:  ldarg.1
    IL_0097:  ldstr      "\" border='0'"
    IL_009c:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_00a1:  ldarg.0
    IL_00a2:  callvirt   instance string [System.Web]System.Web.UI.WebControls.WebControl::get_ToolTip()
    IL_00a7:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_00ac:  ldc.i4.0
    IL_00ad:  ble.s      IL_00ca

    IL_00af:  ldarg.1
    IL_00b0:  ldstr      " alt='"
    IL_00b5:  ldarg.0
    IL_00b6:  callvirt   instance string [System.Web]System.Web.UI.WebControls.WebControl::get_ToolTip()
    IL_00bb:  ldstr      "'"
    IL_00c0:  call       string [mscorlib]System.String::Concat(string,
                                                                string,
                                                                string)
    IL_00c5:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_00ca:  ldarg.1
    IL_00cb:  ldstr      " width="
    IL_00d0:  ldarg.0
    IL_00d1:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_00d6:  callvirt   instance int32 MSCaptcha.CaptchaImage::get_Width()
    IL_00db:  box        [mscorlib]System.Int32
    IL_00e0:  call       string [mscorlib]System.String::Concat(object,
                                                                object)
    IL_00e5:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_00ea:  ldarg.1
    IL_00eb:  ldstr      " height="
    IL_00f0:  ldarg.0
    IL_00f1:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_00f6:  callvirt   instance int32 MSCaptcha.CaptchaImage::get_Height()
    IL_00fb:  box        [mscorlib]System.Int32
    IL_0100:  call       string [mscorlib]System.String::Concat(object,
                                                                object)
    IL_0105:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_010a:  ldarg.1
    IL_010b:  ldstr      ">"
    IL_0110:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_0115:  ldarg.1
    IL_0116:  ldstr      "</div>"
    IL_011b:  callvirt   instance void [mscorlib]System.IO.TextWriter::Write(string)
    IL_0120:  ret
  } // end of method CaptchaControl::Render

  .method private hidebysig instance void 
          GenerateNewCaptcha() cil managed
  {
    // Code size       122 (0x7a)
    .maxstack  8
    .locals init (valuetype [mscorlib]System.DateTime V_0)
    IL_0000:  ldarg.0
    IL_0001:  call       instance bool MSCaptcha.CaptchaControl::get_IsDesignMode()
    IL_0006:  brtrue.s   IL_0079

    IL_0008:  ldarg.0
    IL_0009:  ldfld      valuetype MSCaptcha.CaptchaControl/CacheType MSCaptcha.CaptchaControl::_cacheStrategy
    IL_000e:  brtrue.s   IL_0059

    IL_0010:  call       class [System.Web]System.Web.Caching.Cache [System.Web]System.Web.HttpRuntime::get_Cache()
    IL_0015:  ldarg.0
    IL_0016:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_001b:  callvirt   instance string MSCaptcha.CaptchaImage::get_UniqueId()
    IL_0020:  ldarg.0
    IL_0021:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0026:  ldnull
    IL_0027:  call       valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::get_Now()
    IL_002c:  stloc.0
    IL_002d:  ldloca.s   V_0
    IL_002f:  ldarg.0
    IL_0030:  call       instance int32 MSCaptcha.CaptchaControl::get_CaptchaMaxTimeout()
    IL_0035:  brfalse.s  IL_003f

    IL_0037:  ldarg.0
    IL_0038:  call       instance int32 MSCaptcha.CaptchaControl::get_CaptchaMaxTimeout()
    IL_003d:  br.s       IL_0041

    IL_003f:  ldc.i4.s   90
    IL_0041:  call       float64 [mscorlib]System.Convert::ToDouble(int32)
    IL_0046:  call       instance valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::AddSeconds(float64)
    IL_004b:  ldsfld     valuetype [mscorlib]System.TimeSpan [mscorlib]System.TimeSpan::Zero
    IL_0050:  ldc.i4.6
    IL_0051:  ldnull
    IL_0052:  callvirt   instance object [System.Web]System.Web.Caching.Cache::Add(string,
                                                                                   object,
                                                                                   class [System.Web]System.Web.Caching.CacheDependency,
                                                                                   valuetype [mscorlib]System.DateTime,
                                                                                   valuetype [mscorlib]System.TimeSpan,
                                                                                   valuetype [System.Web]System.Web.Caching.CacheItemPriority,
                                                                                   class [System.Web]System.Web.Caching.CacheItemRemovedCallback)
    IL_0057:  pop
    IL_0058:  ret

    IL_0059:  call       class [System.Web]System.Web.HttpContext [System.Web]System.Web.HttpContext::get_Current()
    IL_005e:  callvirt   instance class [System.Web]System.Web.SessionState.HttpSessionState [System.Web]System.Web.HttpContext::get_Session()
    IL_0063:  ldarg.0
    IL_0064:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0069:  callvirt   instance string MSCaptcha.CaptchaImage::get_UniqueId()
    IL_006e:  ldarg.0
    IL_006f:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0074:  callvirt   instance void [System.Web]System.Web.SessionState.HttpSessionState::Add(string,
                                                                                                 object)
    IL_0079:  ret
  } // end of method CaptchaControl::GenerateNewCaptcha

  .method private hidebysig newslot virtual final 
          instance bool  System.Web.UI.IPostBackDataHandler.LoadPostData(string PostDataKey,
                                                                         class [System]System.Collections.Specialized.NameValueCollection Values) cil managed
  {
    .override [System.Web]System.Web.UI.IPostBackDataHandler::LoadPostData
    // Code size       25 (0x19)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.2
    IL_0002:  ldarg.0
    IL_0003:  callvirt   instance string [System.Web]System.Web.UI.Control::get_UniqueID()
    IL_0008:  callvirt   instance string [System]System.Collections.Specialized.NameValueCollection::get_Item(string)
    IL_000d:  call       string [mscorlib]System.Convert::ToString(string)
    IL_0012:  call       instance void MSCaptcha.CaptchaControl::ValidateCaptcha(string)
    IL_0017:  ldc.i4.0
    IL_0018:  ret
  } // end of method CaptchaControl::System.Web.UI.IPostBackDataHandler.LoadPostData

  .method private hidebysig newslot virtual final 
          instance void  System.Web.UI.IPostBackDataHandler.RaisePostDataChangedEvent() cil managed
  {
    .override [System.Web]System.Web.UI.IPostBackDataHandler::RaisePostDataChangedEvent
    // Code size       1 (0x1)
    .maxstack  8
    IL_0000:  ret
  } // end of method CaptchaControl::System.Web.UI.IPostBackDataHandler.RaisePostDataChangedEvent

  .method family hidebysig virtual instance object 
          SaveControlState() cil managed
  {
    // Code size       12 (0xc)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0006:  callvirt   instance string MSCaptcha.CaptchaImage::get_UniqueId()
    IL_000b:  ret
  } // end of method CaptchaControl::SaveControlState

  .method family hidebysig virtual instance void 
          LoadControlState(object state) cil managed
  {
    // Code size       16 (0x10)
    .maxstack  8
    IL_0000:  ldarg.1
    IL_0001:  brfalse.s  IL_000f

    IL_0003:  ldarg.0
    IL_0004:  ldarg.1
    IL_0005:  castclass  [mscorlib]System.String
    IL_000a:  stfld      string MSCaptcha.CaptchaControl::_prevguid
    IL_000f:  ret
  } // end of method CaptchaControl::LoadControlState

  .method family hidebysig virtual instance void 
          OnInit(class [mscorlib]System.EventArgs e) cil managed
  {
    // Code size       37 (0x25)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  call       instance void [System.Web]System.Web.UI.Control::OnInit(class [mscorlib]System.EventArgs)
    IL_0007:  ldarg.0
    IL_0008:  callvirt   instance class [System.Web]System.Web.UI.Page [System.Web]System.Web.UI.Control::get_Page()
    IL_000d:  ldarg.0
    IL_000e:  callvirt   instance void [System.Web]System.Web.UI.Page::RegisterRequiresControlState(class [System.Web]System.Web.UI.Control)
    IL_0013:  ldarg.0
    IL_0014:  callvirt   instance class [System.Web]System.Web.UI.Page [System.Web]System.Web.UI.Control::get_Page()
    IL_0019:  callvirt   instance class [System.Web]System.Web.UI.ValidatorCollection [System.Web]System.Web.UI.Page::get_Validators()
    IL_001e:  ldarg.0
    IL_001f:  callvirt   instance void [System.Web]System.Web.UI.ValidatorCollection::Add(class [System.Web]System.Web.UI.IValidator)
    IL_0024:  ret
  } // end of method CaptchaControl::OnInit

  .method family hidebysig virtual instance void 
          OnUnload(class [mscorlib]System.EventArgs e) cil managed
  {
    // Code size       33 (0x21)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  callvirt   instance class [System.Web]System.Web.UI.Page [System.Web]System.Web.UI.Control::get_Page()
    IL_0006:  brfalse.s  IL_0019

    IL_0008:  ldarg.0
    IL_0009:  callvirt   instance class [System.Web]System.Web.UI.Page [System.Web]System.Web.UI.Control::get_Page()
    IL_000e:  callvirt   instance class [System.Web]System.Web.UI.ValidatorCollection [System.Web]System.Web.UI.Page::get_Validators()
    IL_0013:  ldarg.0
    IL_0014:  callvirt   instance void [System.Web]System.Web.UI.ValidatorCollection::Remove(class [System.Web]System.Web.UI.IValidator)
    IL_0019:  ldarg.0
    IL_001a:  ldarg.1
    IL_001b:  call       instance void [System.Web]System.Web.UI.Control::OnUnload(class [mscorlib]System.EventArgs)
    IL_0020:  ret
  } // end of method CaptchaControl::OnUnload

  .method family hidebysig virtual instance void 
          OnPreRender(class [mscorlib]System.EventArgs e) cil managed
  {
    // Code size       22 (0x16)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  callvirt   instance bool [System.Web]System.Web.UI.Control::get_Visible()
    IL_0006:  brfalse.s  IL_000e

    IL_0008:  ldarg.0
    IL_0009:  call       instance void MSCaptcha.CaptchaControl::GenerateNewCaptcha()
    IL_000e:  ldarg.0
    IL_000f:  ldarg.1
    IL_0010:  call       instance void [System.Web]System.Web.UI.Control::OnPreRender(class [mscorlib]System.EventArgs)
    IL_0015:  ret
  } // end of method CaptchaControl::OnPreRender

  .method public hidebysig specialname rtspecialname 
          instance void  .ctor() cil managed
  {
    // Code size       117 (0x75)
    .maxstack  2
    IL_0000:  ldarg.0
    IL_0001:  ldc.i4.s   90
    IL_0003:  stfld      int32 MSCaptcha.CaptchaControl::_timeoutSecondsMax
    IL_0008:  ldarg.0
    IL_0009:  ldc.i4.3
    IL_000a:  stfld      int32 MSCaptcha.CaptchaControl::_timeoutSecondsMin
    IL_000f:  ldarg.0
    IL_0010:  ldc.i4.1
    IL_0011:  stfld      bool MSCaptcha.CaptchaControl::_userValidated
    IL_0016:  ldarg.0
    IL_0017:  ldstr      "Enter the code shown:"
    IL_001c:  stfld      string MSCaptcha.CaptchaControl::_text
    IL_0021:  ldarg.0
    IL_0022:  ldstr      ""
    IL_0027:  stfld      string MSCaptcha.CaptchaControl::_font
    IL_002c:  ldarg.0
    IL_002d:  newobj     instance void MSCaptcha.CaptchaImage::.ctor()
    IL_0032:  stfld      class MSCaptcha.CaptchaImage MSCaptcha.CaptchaControl::_captcha
    IL_0037:  ldarg.0
    IL_0038:  ldstr      ""
    IL_003d:  stfld      string MSCaptcha.CaptchaControl::_errorMessage
    IL_0042:  ldarg.0
    IL_0043:  call       valuetype [System.Drawing]System.Drawing.Color [System.Drawing]System.Drawing.Color::get_White()
    IL_0048:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_backColor
    IL_004d:  ldarg.0
    IL_004e:  call       valuetype [System.Drawing]System.Drawing.Color [System.Drawing]System.Drawing.Color::get_Black()
    IL_0053:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_fontColor
    IL_0058:  ldarg.0
    IL_0059:  call       valuetype [System.Drawing]System.Drawing.Color [System.Drawing]System.Drawing.Color::get_Black()
    IL_005e:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_noiseColor
    IL_0063:  ldarg.0
    IL_0064:  call       valuetype [System.Drawing]System.Drawing.Color [System.Drawing]System.Drawing.Color::get_Black()
    IL_0069:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::_lineColor
    IL_006e:  ldarg.0
    IL_006f:  call       instance void [System.Web]System.Web.UI.WebControls.WebControl::.ctor()
    IL_0074:  ret
  } // end of method CaptchaControl::.ctor

  .property instance string CustomValidatorErrorMessage()
  {
    .get instance string MSCaptcha.CaptchaControl::get_CustomValidatorErrorMessage()
    .set instance void MSCaptcha.CaptchaControl::set_CustomValidatorErrorMessage(string)
  } // end of property CaptchaControl::CustomValidatorErrorMessage
  .property instance string ValidationGroup()
  {
    .set instance void MSCaptcha.CaptchaControl::set_ValidationGroup(string)
    .get instance string MSCaptcha.CaptchaControl::get_ValidationGroup()
  } // end of property CaptchaControl::ValidationGroup
  .property instance string System.Web.UI.IValidator.ErrorMessage()
  {
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 0A 41 70 70 65 61 72 61 6E 63 65 00 00 )    // ...Appearance..
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 4E 4D 65 73 73 61 67 65 20 74 6F 20 64 69   // ..NMessage to di
                                                                                                73 70 6C 61 79 20 69 6E 20 61 20 56 61 6C 69 64   // splay in a Valid
                                                                                                61 74 69 6F 6E 20 53 75 6D 6D 61 72 79 20 77 68   // ation Summary wh
                                                                                                65 6E 20 74 68 65 20 43 41 50 54 43 48 41 20 66   // en the CAPTCHA f
                                                                                                61 69 6C 73 20 74 6F 20 76 61 6C 69 64 61 74 65   // ails to validate
                                                                                                2E 00 00 )                                        // ...
    .custom instance void [System]System.ComponentModel.BrowsableAttribute::.ctor(bool) = ( 01 00 00 00 00 ) 
    .custom instance void [System]System.ComponentModel.BindableAttribute::.ctor(bool) = ( 01 00 01 00 00 ) 
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(string) = ( 01 00 38 54 68 65 20 74 65 78 74 20 79 6F 75 20   // ..8The text you 
                                                                                                 74 79 70 65 64 20 64 6F 65 73 20 6E 6F 74 20 6D   // typed does not m
                                                                                                 61 74 63 68 20 74 68 65 20 74 65 78 74 20 69 6E   // atch the text in
                                                                                                 20 74 68 65 20 69 6D 61 67 65 2E 00 00 )          //  the image...
    .set instance void MSCaptcha.CaptchaControl::System.Web.UI.IValidator.set_ErrorMessage(string)
    .get instance string MSCaptcha.CaptchaControl::System.Web.UI.IValidator.get_ErrorMessage()
  } // end of property CaptchaControl::System.Web.UI.IValidator.ErrorMessage
  .property instance bool System.Web.UI.IValidator.IsValid()
  {
    .get instance bool MSCaptcha.CaptchaControl::System.Web.UI.IValidator.get_IsValid()
    .set instance void MSCaptcha.CaptchaControl::System.Web.UI.IValidator.set_IsValid(bool)
  } // end of property CaptchaControl::System.Web.UI.IValidator.IsValid
  .property instance bool Enabled()
  {
    .get instance bool MSCaptcha.CaptchaControl::get_Enabled()
    .set instance void MSCaptcha.CaptchaControl::set_Enabled(bool)
  } // end of property CaptchaControl::Enabled
  .property instance valuetype MSCaptcha.CaptchaControl/CacheType
          CacheStrategy()
  {
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 80 86 44 65 74 65 72 6D 69 6E 65 73 20 69   // ....Determines i
                                                                                                66 20 43 41 50 54 43 48 41 20 63 6F 64 65 73 20   // f CAPTCHA codes 
                                                                                                61 72 65 20 73 74 6F 72 65 64 20 69 6E 20 48 74   // are stored in Ht
                                                                                                74 70 52 75 6E 74 69 6D 65 20 28 66 61 73 74 2C   // tpRuntime (fast,
                                                                                                20 62 75 74 20 6C 6F 63 61 6C 20 74 6F 20 63 75   //  but local to cu
                                                                                                72 72 65 6E 74 20 73 65 72 76 65 72 29 20 6F 72   // rrent server) or
                                                                                                20 53 65 73 73 69 6F 6E 20 28 6D 6F 72 65 20 70   //  Session (more p
                                                                                                6F 72 74 61 62 6C 65 20 61 63 72 6F 73 73 20 77   // ortable across w
                                                                                                65 62 20 66 61 72 6D 73 29 2E 00 00 )             // eb farms)...
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(class [mscorlib]System.Type,
                                                                                     string) = ( 01 00 22 4D 53 43 61 70 74 63 68 61 2E 43 61 70   // .."MSCaptcha.Cap
                                                                                                 74 63 68 61 43 6F 6E 74 72 6F 6C 2B 43 61 63 68   // tchaControl+Cach
                                                                                                 65 54 79 70 65 0B 48 74 74 70 52 75 6E 74 69 6D   // eType.HttpRuntim
                                                                                                 65 00 00 )                                        // e..
    .get instance valuetype MSCaptcha.CaptchaControl/CacheType MSCaptcha.CaptchaControl::get_CacheStrategy()
    .set instance void MSCaptcha.CaptchaControl::set_CacheStrategy(valuetype MSCaptcha.CaptchaControl/CacheType)
  } // end of property CaptchaControl::CacheStrategy
  .property instance bool UserValidated()
  {
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 40 52 65 74 75 72 6E 73 20 54 72 75 65 20   // ..@Returns True 
                                                                                                69 66 20 74 68 65 20 75 73 65 72 20 77 61 73 20   // if the user was 
                                                                                                43 41 50 54 43 48 41 20 76 61 6C 69 64 61 74 65   // CAPTCHA validate
                                                                                                64 20 61 66 74 65 72 20 61 20 70 6F 73 74 62 61   // d after a postba
                                                                                                63 6B 2E 00 00 )                                  // ck...
    .get instance bool MSCaptcha.CaptchaControl::get_UserValidated()
  } // end of property CaptchaControl::UserValidated
  .property instance string CaptchaFont()
  {
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(string) = ( 01 00 00 00 00 ) 
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 56 46 6F 6E 74 20 75 73 65 64 20 74 6F 20   // ..VFont used to 
                                                                                                72 65 6E 64 65 72 20 43 41 50 54 43 48 41 20 74   // render CAPTCHA t
                                                                                                65 78 74 2E 20 49 66 20 66 6F 6E 74 20 6E 61 6D   // ext. If font nam
                                                                                                65 20 69 73 20 62 6C 61 6E 6B 2C 20 61 20 72 61   // e is blank, a ra
                                                                                                6E 64 6F 6D 20 66 6F 6E 74 20 77 69 6C 6C 20 62   // ndom font will b
                                                                                                65 20 63 68 6F 73 65 6E 2E 00 00 )                // e chosen...
    .get instance string MSCaptcha.CaptchaControl::get_CaptchaFont()
    .set instance void MSCaptcha.CaptchaControl::set_CaptchaFont(string)
  } // end of property CaptchaControl::CaptchaFont
  .property instance string CaptchaChars()
  {
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(string) = ( 01 00 20 41 42 43 44 45 46 47 48 4A 4B 4C 4D 4E   // .. ABCDEFGHJKLMN
                                                                                                 50 51 52 53 54 55 56 57 58 59 5A 32 33 34 35 36   // PQRSTUVWXYZ23456
                                                                                                 37 38 39 00 00 )                                  // 789..
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 5C 43 68 61 72 61 63 74 65 72 73 20 75 73   // ..\Characters us
                                                                                                65 64 20 74 6F 20 72 65 6E 64 65 72 20 43 41 50   // ed to render CAP
                                                                                                54 43 48 41 20 74 65 78 74 2E 20 41 20 63 68 61   // TCHA text. A cha
                                                                                                72 61 63 74 65 72 20 77 69 6C 6C 20 62 65 20 70   // racter will be p
                                                                                                69 63 6B 65 64 20 72 61 6E 64 6F 6D 6C 79 20 66   // icked randomly f
                                                                                                72 6F 6D 20 74 68 65 20 73 74 72 69 6E 67 2E 00   // rom the string..
                                                                                                00 ) 
    .get instance string MSCaptcha.CaptchaControl::get_CaptchaChars()
    .set instance void MSCaptcha.CaptchaControl::set_CaptchaChars(string)
  } // end of property CaptchaControl::CaptchaChars
  .property instance int32 CaptchaLength()
  {
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(int32) = ( 01 00 05 00 00 00 00 00 ) 
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 2F 4E 75 6D 62 65 72 20 6F 66 20 43 61 70   // ../Number of Cap
                                                                                                74 63 68 61 43 68 61 72 73 20 75 73 65 64 20 69   // tchaChars used i
                                                                                                6E 20 74 68 65 20 43 41 50 54 43 48 41 20 74 65   // n the CAPTCHA te
                                                                                                78 74 00 00 )                                     // xt..
    .get instance int32 MSCaptcha.CaptchaControl::get_CaptchaLength()
    .set instance void MSCaptcha.CaptchaControl::set_CaptchaLength(int32)
  } // end of property CaptchaControl::CaptchaLength
  .property instance int32 CaptchaMinTimeout()
  {
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(int32) = ( 01 00 02 00 00 00 00 00 ) 
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 80 88 4D 69 6E 69 6D 75 6D 20 6E 75 6D 62   // ....Minimum numb
                                                                                                65 72 20 6F 66 20 73 65 63 6F 6E 64 73 20 43 41   // er of seconds CA
                                                                                                50 54 43 48 41 20 6D 75 73 74 20 62 65 20 64 69   // PTCHA must be di
                                                                                                73 70 6C 61 79 65 64 20 62 65 66 6F 72 65 20 69   // splayed before i
                                                                                                74 20 69 73 20 76 61 6C 69 64 2E 20 49 66 20 79   // t is valid. If y
                                                                                                6F 75 27 72 65 20 74 6F 6F 20 66 61 73 74 2C 20   // ou're too fast, 
                                                                                                79 6F 75 20 6D 75 73 74 20 62 65 20 61 20 72 6F   // you must be a ro
                                                                                                62 6F 74 2E 20 53 65 74 20 74 6F 20 7A 65 72 6F   // bot. Set to zero
                                                                                                20 74 6F 20 64 69 73 61 62 6C 65 2E 00 00 )       //  to disable...
    .get instance int32 MSCaptcha.CaptchaControl::get_CaptchaMinTimeout()
    .set instance void MSCaptcha.CaptchaControl::set_CaptchaMinTimeout(int32)
  } // end of property CaptchaControl::CaptchaMinTimeout
  .property instance int32 CaptchaMaxTimeout()
  {
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(int32) = ( 01 00 5A 00 00 00 00 00 )                         // ..Z.....
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 80 8A 4D 61 78 69 6D 75 6D 20 6E 75 6D 62   // ....Maximum numb
                                                                                                65 72 20 6F 66 20 73 65 63 6F 6E 64 73 20 43 41   // er of seconds CA
                                                                                                50 54 43 48 41 20 77 69 6C 6C 20 62 65 20 63 61   // PTCHA will be ca
                                                                                                63 68 65 64 20 61 6E 64 20 76 61 6C 69 64 2E 20   // ched and valid. 
                                                                                                49 66 20 79 6F 75 27 72 65 20 74 6F 6F 20 73 6C   // If you're too sl
                                                                                                6F 77 2C 20 79 6F 75 20 6D 61 79 20 62 65 20 61   // ow, you may be a
                                                                                                20 43 41 50 54 43 48 41 20 68 61 63 6B 20 61 74   //  CAPTCHA hack at
                                                                                                74 65 6D 70 74 2E 20 53 65 74 20 74 6F 20 7A 65   // tempt. Set to ze
                                                                                                72 6F 20 74 6F 20 64 69 73 61 62 6C 65 2E 00 00 ) // ro to disable...
    .get instance int32 MSCaptcha.CaptchaControl::get_CaptchaMaxTimeout()
    .set instance void MSCaptcha.CaptchaControl::set_CaptchaMaxTimeout(int32)
  } // end of property CaptchaControl::CaptchaMaxTimeout
  .property instance int32 CaptchaHeight()
  {
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(int32) = ( 01 00 32 00 00 00 00 00 )                         // ..2.....
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 22 48 65 69 67 68 74 20 6F 66 20 67 65 6E   // .."Height of gen
                                                                                                65 72 61 74 65 64 20 43 41 50 54 43 48 41 20 69   // erated CAPTCHA i
                                                                                                6D 61 67 65 2E 00 00 )                            // mage...
    .get instance int32 MSCaptcha.CaptchaControl::get_CaptchaHeight()
    .set instance void MSCaptcha.CaptchaControl::set_CaptchaHeight(int32)
  } // end of property CaptchaControl::CaptchaHeight
  .property instance int32 CaptchaWidth()
  {
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(int32) = ( 01 00 B4 00 00 00 00 00 ) 
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 21 57 69 64 74 68 20 6F 66 20 67 65 6E 65   // ..!Width of gene
                                                                                                72 61 74 65 64 20 43 41 50 54 43 48 41 20 69 6D   // rated CAPTCHA im
                                                                                                61 67 65 2E 00 00 )                               // age...
    .set instance void MSCaptcha.CaptchaControl::set_CaptchaWidth(int32)
    .get instance int32 MSCaptcha.CaptchaControl::get_CaptchaWidth()
  } // end of property CaptchaControl::CaptchaWidth
  .property instance valuetype MSCaptcha.CaptchaImage/FontWarpFactor
          CaptchaFontWarping()
  {
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(class [mscorlib]System.Type,
                                                                                     string) = ( 01 00 25 4D 53 43 61 70 74 63 68 61 2E 43 61 70   // ..%MSCaptcha.Cap
                                                                                                 74 63 68 61 49 6D 61 67 65 2B 46 6F 6E 74 57 61   // tchaImage+FontWa
                                                                                                 72 70 46 61 63 74 6F 72 03 4C 6F 77 00 00 )       // rpFactor.Low..
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 36 41 6D 6F 75 6E 74 20 6F 66 20 72 61 6E   // ..6Amount of ran
                                                                                                64 6F 6D 20 66 6F 6E 74 20 77 61 72 70 69 6E 67   // dom font warping
                                                                                                20 75 73 65 64 20 6F 6E 20 74 68 65 20 43 41 50   //  used on the CAP
                                                                                                54 43 48 41 20 74 65 78 74 00 00 )                // TCHA text..
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .get instance valuetype MSCaptcha.CaptchaImage/FontWarpFactor MSCaptcha.CaptchaControl::get_CaptchaFontWarping()
    .set instance void MSCaptcha.CaptchaControl::set_CaptchaFontWarping(valuetype MSCaptcha.CaptchaImage/FontWarpFactor)
  } // end of property CaptchaControl::CaptchaFontWarping
  .property instance valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel
          CaptchaBackgroundNoise()
  {
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(class [mscorlib]System.Type,
                                                                                     string) = ( 01 00 2B 4D 53 43 61 70 74 63 68 61 2E 43 61 70   // ..+MSCaptcha.Cap
                                                                                                 74 63 68 61 49 6D 61 67 65 2B 42 61 63 6B 67 72   // tchaImage+Backgr
                                                                                                 6F 75 6E 64 4E 6F 69 73 65 4C 65 76 65 6C 03 4C   // oundNoiseLevel.L
                                                                                                 6F 77 00 00 )                                     // ow..
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 3B 41 6D 6F 75 6E 74 20 6F 66 20 62 61 63   // ..;Amount of bac
                                                                                                6B 67 72 6F 75 6E 64 20 6E 6F 69 73 65 20 74 6F   // kground noise to
                                                                                                20 67 65 6E 65 72 61 74 65 20 69 6E 20 74 68 65   //  generate in the
                                                                                                20 43 41 50 54 43 48 41 20 69 6D 61 67 65 00 00 ) //  CAPTCHA image..
    .set instance void MSCaptcha.CaptchaControl::set_CaptchaBackgroundNoise(valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel)
    .get instance valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel MSCaptcha.CaptchaControl::get_CaptchaBackgroundNoise()
  } // end of property CaptchaControl::CaptchaBackgroundNoise
  .property instance valuetype MSCaptcha.CaptchaImage/LineNoiseLevel
          CaptchaLineNoise()
  {
    .custom instance void [System]System.ComponentModel.DescriptionAttribute::.ctor(string) = ( 01 00 23 41 64 64 20 6C 69 6E 65 20 6E 6F 69 73   // ..#Add line nois
                                                                                                65 20 74 6F 20 74 68 65 20 43 41 50 54 43 48 41   // e to the CAPTCHA
                                                                                                20 69 6D 61 67 65 00 00 )                         //  image..
    .custom instance void [System]System.ComponentModel.CategoryAttribute::.ctor(string) = ( 01 00 07 43 61 70 74 63 68 61 00 00 )             // ...Captcha..
    .custom instance void [System]System.ComponentModel.DefaultValueAttribute::.ctor(class [mscorlib]System.Type,
                                                                                     string) = ( 01 00 25 4D 53 43 61 70 74 63 68 61 2E 43 61 70   // ..%MSCaptcha.Cap
                                                                                                 74 63 68 61 49 6D 61 67 65 2B 4C 69 6E 65 4E 6F   // tchaImage+LineNo
                                                                                                 69 73 65 4C 65 76 65 6C 04 4E 6F 6E 65 00 00 )    // iseLevel.None..
    .set instance void MSCaptcha.CaptchaControl::set_CaptchaLineNoise(valuetype MSCaptcha.CaptchaImage/LineNoiseLevel)
    .get instance valuetype MSCaptcha.CaptchaImage/LineNoiseLevel MSCaptcha.CaptchaControl::get_CaptchaLineNoise()
  } // end of property CaptchaControl::CaptchaLineNoise
  .property instance valuetype [System.Drawing]System.Drawing.Color
          BackColor()
  {
    .get instance valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::get_BackColor()
    .set instance void MSCaptcha.CaptchaControl::set_BackColor(valuetype [System.Drawing]System.Drawing.Color)
  } // end of property CaptchaControl::BackColor
  .property instance valuetype [System.Drawing]System.Drawing.Color
          FontColor()
  {
    .get instance valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::get_FontColor()
    .set instance void MSCaptcha.CaptchaControl::set_FontColor(valuetype [System.Drawing]System.Drawing.Color)
  } // end of property CaptchaControl::FontColor
  .property instance valuetype [System.Drawing]System.Drawing.Color
          NoiseColor()
  {
    .get instance valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::get_NoiseColor()
    .set instance void MSCaptcha.CaptchaControl::set_NoiseColor(valuetype [System.Drawing]System.Drawing.Color)
  } // end of property CaptchaControl::NoiseColor
  .property instance valuetype [System.Drawing]System.Drawing.Color
          LineColor()
  {
    .get instance valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaControl::get_LineColor()
    .set instance void MSCaptcha.CaptchaControl::set_LineColor(valuetype [System.Drawing]System.Drawing.Color)
  } // end of property CaptchaControl::LineColor
  .property instance bool IsDesignMode()
  {
    .get instance bool MSCaptcha.CaptchaControl::get_IsDesignMode()
  } // end of property CaptchaControl::IsDesignMode
} // end of class MSCaptcha.CaptchaControl

.class public auto ansi beforefieldinit MSCaptcha.CaptchaImageHandler
       extends [mscorlib]System.Object
       implements [System.Web]System.Web.IHttpHandler
{
  .method private hidebysig newslot virtual final 
          instance void  System.Web.IHttpHandler.ProcessRequest(class [System.Web]System.Web.HttpContext context) cil managed
  {
    .override [System.Web]System.Web.IHttpHandler::ProcessRequest
    // Code size       234 (0xea)
    .maxstack  3
    .locals init (class [System.Web]System.Web.HttpApplication V_0,
             string V_1,
             class MSCaptcha.CaptchaImage V_2,
             class [System.Drawing]System.Drawing.Bitmap V_3)
    IL_0000:  ldarg.1
    IL_0001:  callvirt   instance class [System.Web]System.Web.HttpApplication [System.Web]System.Web.HttpContext::get_ApplicationInstance()
    IL_0006:  stloc.0
    IL_0007:  ldloc.0
    IL_0008:  callvirt   instance class [System.Web]System.Web.HttpRequest [System.Web]System.Web.HttpApplication::get_Request()
    IL_000d:  callvirt   instance class [System]System.Collections.Specialized.NameValueCollection [System.Web]System.Web.HttpRequest::get_QueryString()
    IL_0012:  ldstr      "guid"
    IL_0017:  callvirt   instance string [System]System.Collections.Specialized.NameValueCollection::get_Item(string)
    IL_001c:  stloc.1
    IL_001d:  ldnull
    IL_001e:  stloc.2
    IL_001f:  ldloc.1
    IL_0020:  ldstr      ""
    IL_0025:  call       bool [mscorlib]System.String::op_Inequality(string,
                                                                     string)
    IL_002a:  brfalse.s  IL_0071

    IL_002c:  ldloc.0
    IL_002d:  callvirt   instance class [System.Web]System.Web.HttpRequest [System.Web]System.Web.HttpApplication::get_Request()
    IL_0032:  callvirt   instance class [System]System.Collections.Specialized.NameValueCollection [System.Web]System.Web.HttpRequest::get_QueryString()
    IL_0037:  ldstr      "s"
    IL_003c:  callvirt   instance string [System]System.Collections.Specialized.NameValueCollection::get_Item(string)
    IL_0041:  call       bool [mscorlib]System.String::IsNullOrEmpty(string)
    IL_0046:  brfalse.s  IL_005b

    IL_0048:  call       class [System.Web]System.Web.Caching.Cache [System.Web]System.Web.HttpRuntime::get_Cache()
    IL_004d:  ldloc.1
    IL_004e:  callvirt   instance object [System.Web]System.Web.Caching.Cache::Get(string)
    IL_0053:  castclass  MSCaptcha.CaptchaImage
    IL_0058:  stloc.2
    IL_0059:  br.s       IL_0071

    IL_005b:  call       class [System.Web]System.Web.HttpContext [System.Web]System.Web.HttpContext::get_Current()
    IL_0060:  callvirt   instance class [System.Web]System.Web.SessionState.HttpSessionState [System.Web]System.Web.HttpContext::get_Session()
    IL_0065:  ldloc.1
    IL_0066:  callvirt   instance object [System.Web]System.Web.SessionState.HttpSessionState::get_Item(string)
    IL_006b:  castclass  MSCaptcha.CaptchaImage
    IL_0070:  stloc.2
    IL_0071:  ldloc.2
    IL_0072:  brtrue.s   IL_0090

    IL_0074:  ldloc.0
    IL_0075:  callvirt   instance class [System.Web]System.Web.HttpResponse [System.Web]System.Web.HttpApplication::get_Response()
    IL_007a:  ldc.i4     0x194
    IL_007f:  callvirt   instance void [System.Web]System.Web.HttpResponse::set_StatusCode(int32)
    IL_0084:  ldarg.1
    IL_0085:  callvirt   instance class [System.Web]System.Web.HttpApplication [System.Web]System.Web.HttpContext::get_ApplicationInstance()
    IL_008a:  callvirt   instance void [System.Web]System.Web.HttpApplication::CompleteRequest()
    IL_008f:  ret

    IL_0090:  ldloc.2
    IL_0091:  callvirt   instance class [System.Drawing]System.Drawing.Bitmap MSCaptcha.CaptchaImage::RenderImage()
    IL_0096:  stloc.3
    .try
    {
      IL_0097:  ldloc.3
      IL_0098:  ldloc.0
      IL_0099:  callvirt   instance class [System.Web]System.Web.HttpContext [System.Web]System.Web.HttpApplication::get_Context()
      IL_009e:  callvirt   instance class [System.Web]System.Web.HttpResponse [System.Web]System.Web.HttpContext::get_Response()
      IL_00a3:  callvirt   instance class [mscorlib]System.IO.Stream [System.Web]System.Web.HttpResponse::get_OutputStream()
      IL_00a8:  call       class [System.Drawing]System.Drawing.Imaging.ImageFormat [System.Drawing]System.Drawing.Imaging.ImageFormat::get_Jpeg()
      IL_00ad:  callvirt   instance void [System.Drawing]System.Drawing.Image::Save(class [mscorlib]System.IO.Stream,
                                                                                    class [System.Drawing]System.Drawing.Imaging.ImageFormat)
      IL_00b2:  leave.s    IL_00be

    }  // end .try
    finally
    {
      IL_00b4:  ldloc.3
      IL_00b5:  brfalse.s  IL_00bd

      IL_00b7:  ldloc.3
      IL_00b8:  callvirt   instance void [mscorlib]System.IDisposable::Dispose()
      IL_00bd:  endfinally
    }  // end handler
    IL_00be:  ldloc.0
    IL_00bf:  callvirt   instance class [System.Web]System.Web.HttpResponse [System.Web]System.Web.HttpApplication::get_Response()
    IL_00c4:  ldstr      "image/jpeg"
    IL_00c9:  callvirt   instance void [System.Web]System.Web.HttpResponse::set_ContentType(string)
    IL_00ce:  ldloc.0
    IL_00cf:  callvirt   instance class [System.Web]System.Web.HttpResponse [System.Web]System.Web.HttpApplication::get_Response()
    IL_00d4:  ldc.i4     0xc8
    IL_00d9:  callvirt   instance void [System.Web]System.Web.HttpResponse::set_StatusCode(int32)
    IL_00de:  ldarg.1
    IL_00df:  callvirt   instance class [System.Web]System.Web.HttpApplication [System.Web]System.Web.HttpContext::get_ApplicationInstance()
    IL_00e4:  callvirt   instance void [System.Web]System.Web.HttpApplication::CompleteRequest()
    IL_00e9:  ret
  } // end of method CaptchaImageHandler::System.Web.IHttpHandler.ProcessRequest

  .method private hidebysig newslot specialname virtual final 
          instance bool  System.Web.IHttpHandler.get_IsReusable() cil managed
  {
    .override [System.Web]System.Web.IHttpHandler::get_IsReusable
    // Code size       2 (0x2)
    .maxstack  8
    IL_0000:  ldc.i4.1
    IL_0001:  ret
  } // end of method CaptchaImageHandler::System.Web.IHttpHandler.get_IsReusable

  .method public hidebysig specialname rtspecialname 
          instance void  .ctor() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  call       instance void [mscorlib]System.Object::.ctor()
    IL_0006:  ret
  } // end of method CaptchaImageHandler::.ctor

  .property instance bool System.Web.IHttpHandler.IsReusable()
  {
    .get instance bool MSCaptcha.CaptchaImageHandler::System.Web.IHttpHandler.get_IsReusable()
  } // end of property CaptchaImageHandler::System.Web.IHttpHandler.IsReusable
} // end of class MSCaptcha.CaptchaImageHandler

.class public auto ansi beforefieldinit MSCaptcha.CaptchaImage
       extends [mscorlib]System.Object
{
  .class auto ansi sealed nested public FontWarpFactor
         extends [mscorlib]System.Enum
  {
    .field public specialname rtspecialname int32 value__
    .field public static literal valuetype MSCaptcha.CaptchaImage/FontWarpFactor None = int32(0x00000000)
    .field public static literal valuetype MSCaptcha.CaptchaImage/FontWarpFactor Low = int32(0x00000001)
    .field public static literal valuetype MSCaptcha.CaptchaImage/FontWarpFactor Medium = int32(0x00000002)
    .field public static literal valuetype MSCaptcha.CaptchaImage/FontWarpFactor High = int32(0x00000003)
    .field public static literal valuetype MSCaptcha.CaptchaImage/FontWarpFactor Extreme = int32(0x00000004)
  } // end of class FontWarpFactor

  .class auto ansi sealed nested public BackgroundNoiseLevel
         extends [mscorlib]System.Enum
  {
    .field public specialname rtspecialname int32 value__
    .field public static literal valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel None = int32(0x00000000)
    .field public static literal valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel Low = int32(0x00000001)
    .field public static literal valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel Medium = int32(0x00000002)
    .field public static literal valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel High = int32(0x00000003)
    .field public static literal valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel Extreme = int32(0x00000004)
  } // end of class BackgroundNoiseLevel

  .class auto ansi sealed nested public LineNoiseLevel
         extends [mscorlib]System.Enum
  {
    .field public specialname rtspecialname int32 value__
    .field public static literal valuetype MSCaptcha.CaptchaImage/LineNoiseLevel None = int32(0x00000000)
    .field public static literal valuetype MSCaptcha.CaptchaImage/LineNoiseLevel Low = int32(0x00000001)
    .field public static literal valuetype MSCaptcha.CaptchaImage/LineNoiseLevel Medium = int32(0x00000002)
    .field public static literal valuetype MSCaptcha.CaptchaImage/LineNoiseLevel High = int32(0x00000003)
    .field public static literal valuetype MSCaptcha.CaptchaImage/LineNoiseLevel Extreme = int32(0x00000004)
  } // end of class LineNoiseLevel

  .field private int32 _height
  .field private int32 _width
  .field private class [mscorlib]System.Random _rand
  .field private valuetype [mscorlib]System.DateTime _generatedAt
  .field private string _randomText
  .field private int32 _randomTextLength
  .field private string _randomTextChars
  .field private string _fontFamilyName
  .field private valuetype MSCaptcha.CaptchaImage/FontWarpFactor _fontWarp
  .field private valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel _backgroundNoise
  .field private valuetype MSCaptcha.CaptchaImage/LineNoiseLevel _lineNoise
  .field private string _guid
  .field private string _fontWhitelist
  .field private valuetype [System.Drawing]System.Drawing.Color _backColor
  .field private valuetype [System.Drawing]System.Drawing.Color _fontColor
  .field private valuetype [System.Drawing]System.Drawing.Color _noiseColor
  .field private valuetype [System.Drawing]System.Drawing.Color _lineColor
  .method public hidebysig specialname instance string 
          get_UniqueId() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      string MSCaptcha.CaptchaImage::_guid
    IL_0006:  ret
  } // end of method CaptchaImage::get_UniqueId

  .method public hidebysig specialname instance valuetype [mscorlib]System.DateTime 
          get_RenderedAt() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype [mscorlib]System.DateTime MSCaptcha.CaptchaImage::_generatedAt
    IL_0006:  ret
  } // end of method CaptchaImage::get_RenderedAt

  .method public hidebysig specialname instance string 
          get_Font() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      string MSCaptcha.CaptchaImage::_fontFamilyName
    IL_0006:  ret
  } // end of method CaptchaImage::get_Font

  .method public hidebysig specialname instance void 
          set_Font(string 'value') cil managed
  {
    // Code size       52 (0x34)
    .maxstack  3
    .locals init (class [System.Drawing]System.Drawing.Font V_0)
    IL_0000:  ldnull
    IL_0001:  stloc.0
    .try
    {
      .try
      {
        IL_0002:  ldarg.1
        IL_0003:  ldc.r4     12.
        IL_0008:  newobj     instance void [System.Drawing]System.Drawing.Font::.ctor(string,
                                                                                      float32)
        IL_000d:  stloc.0
        IL_000e:  ldarg.0
        IL_000f:  ldarg.1
        IL_0010:  stfld      string MSCaptcha.CaptchaImage::_fontFamilyName
        IL_0015:  leave.s    IL_002a

      }  // end .try
      catch [mscorlib]System.Exception 
      {
        IL_0017:  pop
        IL_0018:  ldarg.0
        IL_0019:  call       class [System.Drawing]System.Drawing.FontFamily [System.Drawing]System.Drawing.FontFamily::get_GenericSerif()
        IL_001e:  callvirt   instance string [System.Drawing]System.Drawing.FontFamily::get_Name()
        IL_0023:  stfld      string MSCaptcha.CaptchaImage::_fontFamilyName
        IL_0028:  leave.s    IL_002a

      }  // end handler
      IL_002a:  leave.s    IL_0033

    }  // end .try
    finally
    {
      IL_002c:  ldloc.0
      IL_002d:  callvirt   instance void [System.Drawing]System.Drawing.Font::Dispose()
      IL_0032:  endfinally
    }  // end handler
    IL_0033:  ret
  } // end of method CaptchaImage::set_Font

  .method public hidebysig specialname instance valuetype MSCaptcha.CaptchaImage/FontWarpFactor 
          get_FontWarp() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype MSCaptcha.CaptchaImage/FontWarpFactor MSCaptcha.CaptchaImage::_fontWarp
    IL_0006:  ret
  } // end of method CaptchaImage::get_FontWarp

  .method public hidebysig specialname instance void 
          set_FontWarp(valuetype MSCaptcha.CaptchaImage/FontWarpFactor 'value') cil managed
  {
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype MSCaptcha.CaptchaImage/FontWarpFactor MSCaptcha.CaptchaImage::_fontWarp
    IL_0007:  ret
  } // end of method CaptchaImage::set_FontWarp

  .method public hidebysig specialname instance valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel 
          get_BackgroundNoise() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel MSCaptcha.CaptchaImage::_backgroundNoise
    IL_0006:  ret
  } // end of method CaptchaImage::get_BackgroundNoise

  .method public hidebysig specialname instance void 
          set_BackgroundNoise(valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel 'value') cil managed
  {
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel MSCaptcha.CaptchaImage::_backgroundNoise
    IL_0007:  ret
  } // end of method CaptchaImage::set_BackgroundNoise

  .method public hidebysig specialname instance valuetype MSCaptcha.CaptchaImage/LineNoiseLevel 
          get_LineNoise() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype MSCaptcha.CaptchaImage/LineNoiseLevel MSCaptcha.CaptchaImage::_lineNoise
    IL_0006:  ret
  } // end of method CaptchaImage::get_LineNoise

  .method public hidebysig specialname instance void 
          set_LineNoise(valuetype MSCaptcha.CaptchaImage/LineNoiseLevel 'value') cil managed
  {
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype MSCaptcha.CaptchaImage/LineNoiseLevel MSCaptcha.CaptchaImage::_lineNoise
    IL_0007:  ret
  } // end of method CaptchaImage::set_LineNoise

  .method public hidebysig specialname instance string 
          get_TextChars() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      string MSCaptcha.CaptchaImage::_randomTextChars
    IL_0006:  ret
  } // end of method CaptchaImage::get_TextChars

  .method public hidebysig specialname instance void 
          set_TextChars(string 'value') cil managed
  {
    // Code size       20 (0x14)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      string MSCaptcha.CaptchaImage::_randomTextChars
    IL_0007:  ldarg.0
    IL_0008:  ldarg.0
    IL_0009:  call       instance string MSCaptcha.CaptchaImage::GenerateRandomText()
    IL_000e:  stfld      string MSCaptcha.CaptchaImage::_randomText
    IL_0013:  ret
  } // end of method CaptchaImage::set_TextChars

  .method public hidebysig specialname instance int32 
          get_TextLength() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      int32 MSCaptcha.CaptchaImage::_randomTextLength
    IL_0006:  ret
  } // end of method CaptchaImage::get_TextLength

  .method public hidebysig specialname instance void 
          set_TextLength(int32 'value') cil managed
  {
    // Code size       20 (0x14)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      int32 MSCaptcha.CaptchaImage::_randomTextLength
    IL_0007:  ldarg.0
    IL_0008:  ldarg.0
    IL_0009:  call       instance string MSCaptcha.CaptchaImage::GenerateRandomText()
    IL_000e:  stfld      string MSCaptcha.CaptchaImage::_randomText
    IL_0013:  ret
  } // end of method CaptchaImage::set_TextLength

  .method public hidebysig specialname instance string 
          get_Text() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      string MSCaptcha.CaptchaImage::_randomText
    IL_0006:  ret
  } // end of method CaptchaImage::get_Text

  .method public hidebysig specialname instance int32 
          get_Width() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      int32 MSCaptcha.CaptchaImage::_width
    IL_0006:  ret
  } // end of method CaptchaImage::get_Width

  .method public hidebysig specialname instance void 
          set_Width(int32 'value') cil managed
  {
    // Code size       35 (0x23)
    .maxstack  8
    IL_0000:  ldarg.1
    IL_0001:  ldc.i4.s   60
    IL_0003:  bgt.s      IL_001b

    IL_0005:  ldstr      "width"
    IL_000a:  ldarg.1
    IL_000b:  box        [mscorlib]System.Int32
    IL_0010:  ldstr      "width must be greater than 60."
    IL_0015:  newobj     instance void [mscorlib]System.ArgumentOutOfRangeException::.ctor(string,
                                                                                           object,
                                                                                           string)
    IL_001a:  throw

    IL_001b:  ldarg.0
    IL_001c:  ldarg.1
    IL_001d:  stfld      int32 MSCaptcha.CaptchaImage::_width
    IL_0022:  ret
  } // end of method CaptchaImage::set_Width

  .method public hidebysig specialname instance int32 
          get_Height() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      int32 MSCaptcha.CaptchaImage::_height
    IL_0006:  ret
  } // end of method CaptchaImage::get_Height

  .method public hidebysig specialname instance void 
          set_Height(int32 'value') cil managed
  {
    // Code size       35 (0x23)
    .maxstack  8
    IL_0000:  ldarg.1
    IL_0001:  ldc.i4.s   30
    IL_0003:  bgt.s      IL_001b

    IL_0005:  ldstr      "height"
    IL_000a:  ldarg.1
    IL_000b:  box        [mscorlib]System.Int32
    IL_0010:  ldstr      "height must be greater than 30."
    IL_0015:  newobj     instance void [mscorlib]System.ArgumentOutOfRangeException::.ctor(string,
                                                                                           object,
                                                                                           string)
    IL_001a:  throw

    IL_001b:  ldarg.0
    IL_001c:  ldarg.1
    IL_001d:  stfld      int32 MSCaptcha.CaptchaImage::_height
    IL_0022:  ret
  } // end of method CaptchaImage::set_Height

  .method public hidebysig specialname instance string 
          get_FontWhitelist() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      string MSCaptcha.CaptchaImage::_fontWhitelist
    IL_0006:  ret
  } // end of method CaptchaImage::get_FontWhitelist

  .method public hidebysig specialname instance void 
          set_FontWhitelist(string 'value') cil managed
  {
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      string MSCaptcha.CaptchaImage::_fontWhitelist
    IL_0007:  ret
  } // end of method CaptchaImage::set_FontWhitelist

  .method public hidebysig specialname instance valuetype [System.Drawing]System.Drawing.Color 
          get_BackColor() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_backColor
    IL_0006:  ret
  } // end of method CaptchaImage::get_BackColor

  .method public hidebysig specialname instance void 
          set_BackColor(valuetype [System.Drawing]System.Drawing.Color 'value') cil managed
  {
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_backColor
    IL_0007:  ret
  } // end of method CaptchaImage::set_BackColor

  .method public hidebysig specialname instance valuetype [System.Drawing]System.Drawing.Color 
          get_FontColor() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_fontColor
    IL_0006:  ret
  } // end of method CaptchaImage::get_FontColor

  .method public hidebysig specialname instance void 
          set_FontColor(valuetype [System.Drawing]System.Drawing.Color 'value') cil managed
  {
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_fontColor
    IL_0007:  ret
  } // end of method CaptchaImage::set_FontColor

  .method public hidebysig specialname instance valuetype [System.Drawing]System.Drawing.Color 
          get_NoiseColor() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_noiseColor
    IL_0006:  ret
  } // end of method CaptchaImage::get_NoiseColor

  .method public hidebysig specialname instance void 
          set_NoiseColor(valuetype [System.Drawing]System.Drawing.Color 'value') cil managed
  {
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_noiseColor
    IL_0007:  ret
  } // end of method CaptchaImage::set_NoiseColor

  .method public hidebysig specialname instance valuetype [System.Drawing]System.Drawing.Color 
          get_LineColor() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_lineColor
    IL_0006:  ret
  } // end of method CaptchaImage::get_LineColor

  .method public hidebysig specialname instance void 
          set_LineColor(valuetype [System.Drawing]System.Drawing.Color 'value') cil managed
  {
    // Code size       8 (0x8)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarg.1
    IL_0002:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_lineColor
    IL_0007:  ret
  } // end of method CaptchaImage::set_LineColor

  .method public hidebysig specialname rtspecialname 
          instance void  .ctor() cil managed
  {
    // Code size       190 (0xbe)
    .maxstack  2
    .locals init (valuetype [mscorlib]System.Guid V_0)
    IL_0000:  ldarg.0
    IL_0001:  call       valuetype [System.Drawing]System.Drawing.Color [System.Drawing]System.Drawing.Color::get_White()
    IL_0006:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_backColor
    IL_000b:  ldarg.0
    IL_000c:  call       valuetype [System.Drawing]System.Drawing.Color [System.Drawing]System.Drawing.Color::get_Black()
    IL_0011:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_fontColor
    IL_0016:  ldarg.0
    IL_0017:  call       valuetype [System.Drawing]System.Drawing.Color [System.Drawing]System.Drawing.Color::get_Black()
    IL_001c:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_noiseColor
    IL_0021:  ldarg.0
    IL_0022:  call       valuetype [System.Drawing]System.Drawing.Color [System.Drawing]System.Drawing.Color::get_Black()
    IL_0027:  stfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_lineColor
    IL_002c:  ldarg.0
    IL_002d:  call       instance void [mscorlib]System.Object::.ctor()
    IL_0032:  ldarg.0
    IL_0033:  newobj     instance void [mscorlib]System.Random::.ctor()
    IL_0038:  stfld      class [mscorlib]System.Random MSCaptcha.CaptchaImage::_rand
    IL_003d:  ldarg.0
    IL_003e:  ldc.i4.1
    IL_003f:  stfld      valuetype MSCaptcha.CaptchaImage/FontWarpFactor MSCaptcha.CaptchaImage::_fontWarp
    IL_0044:  ldarg.0
    IL_0045:  ldc.i4.1
    IL_0046:  stfld      valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel MSCaptcha.CaptchaImage::_backgroundNoise
    IL_004b:  ldarg.0
    IL_004c:  ldc.i4.0
    IL_004d:  stfld      valuetype MSCaptcha.CaptchaImage/LineNoiseLevel MSCaptcha.CaptchaImage::_lineNoise
    IL_0052:  ldarg.0
    IL_0053:  ldc.i4     0xb4
    IL_0058:  stfld      int32 MSCaptcha.CaptchaImage::_width
    IL_005d:  ldarg.0
    IL_005e:  ldc.i4.s   50
    IL_0060:  stfld      int32 MSCaptcha.CaptchaImage::_height
    IL_0065:  ldarg.0
    IL_0066:  ldc.i4.5
    IL_0067:  stfld      int32 MSCaptcha.CaptchaImage::_randomTextLength
    IL_006c:  ldarg.0
    IL_006d:  ldstr      "ACDEFGHJKLNPQRTUVXYZ2346789"
    IL_0072:  stfld      string MSCaptcha.CaptchaImage::_randomTextChars
    IL_0077:  ldarg.0
    IL_0078:  ldstr      ""
    IL_007d:  stfld      string MSCaptcha.CaptchaImage::_fontFamilyName
    IL_0082:  ldarg.0
    IL_0083:  ldstr      "arial;arial black;comic sans ms;courier new;estran"
    + "gelo edessa;franklin gothic medium;georgia;lucida console;lucida sans u"
    + "nicode;mangal;microsoft sans serif;palatino linotype;sylfaen;tahoma;tim"
    + "es new roman;trebuchet ms;verdana"
    IL_0088:  stfld      string MSCaptcha.CaptchaImage::_fontWhitelist
    IL_008d:  ldarg.0
    IL_008e:  ldarg.0
    IL_008f:  call       instance string MSCaptcha.CaptchaImage::GenerateRandomText()
    IL_0094:  stfld      string MSCaptcha.CaptchaImage::_randomText
    IL_0099:  ldarg.0
    IL_009a:  call       valuetype [mscorlib]System.DateTime [mscorlib]System.DateTime::get_Now()
    IL_009f:  stfld      valuetype [mscorlib]System.DateTime MSCaptcha.CaptchaImage::_generatedAt
    IL_00a4:  ldarg.0
    IL_00a5:  call       valuetype [mscorlib]System.Guid [mscorlib]System.Guid::NewGuid()
    IL_00aa:  stloc.0
    IL_00ab:  ldloca.s   V_0
    IL_00ad:  constrained. [mscorlib]System.Guid
    IL_00b3:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_00b8:  stfld      string MSCaptcha.CaptchaImage::_guid
    IL_00bd:  ret
  } // end of method CaptchaImage::.ctor

  .method public hidebysig instance class [System.Drawing]System.Drawing.Bitmap 
          RenderImage() cil managed
  {
    // Code size       7 (0x7)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  call       instance class [System.Drawing]System.Drawing.Bitmap MSCaptcha.CaptchaImage::GenerateImagePrivate()
    IL_0006:  ret
  } // end of method CaptchaImage::RenderImage

  .method private hidebysig instance string 
          RandomFontFamily() cil managed
  {
    // Code size       48 (0x30)
    .maxstack  4
    .locals init (string[] V_0,
             char[] V_1)
    IL_0000:  ldnull
    IL_0001:  stloc.0
    IL_0002:  ldloc.0
    IL_0003:  brtrue.s   IL_001e

    IL_0005:  ldarg.0
    IL_0006:  ldfld      string MSCaptcha.CaptchaImage::_fontWhitelist
    IL_000b:  ldc.i4.1
    IL_000c:  newarr     [mscorlib]System.Char
    IL_0011:  stloc.1
    IL_0012:  ldloc.1
    IL_0013:  ldc.i4.0
    IL_0014:  ldc.i4.s   59
    IL_0016:  stelem.i2
    IL_0017:  ldloc.1
    IL_0018:  callvirt   instance string[] [mscorlib]System.String::Split(char[])
    IL_001d:  stloc.0
    IL_001e:  ldloc.0
    IL_001f:  ldarg.0
    IL_0020:  ldfld      class [mscorlib]System.Random MSCaptcha.CaptchaImage::_rand
    IL_0025:  ldc.i4.0
    IL_0026:  ldloc.0
    IL_0027:  ldlen
    IL_0028:  conv.i4
    IL_0029:  callvirt   instance int32 [mscorlib]System.Random::Next(int32,
                                                                      int32)
    IL_002e:  ldelem.ref
    IL_002f:  ret
  } // end of method CaptchaImage::RandomFontFamily

  .method private hidebysig instance string 
          GenerateRandomText() cil managed
  {
    // Code size       81 (0x51)
    .maxstack  4
    .locals init (class [mscorlib]System.Text.StringBuilder V_0,
             int32 V_1,
             int32 V_2)
    IL_0000:  ldarg.0
    IL_0001:  ldfld      int32 MSCaptcha.CaptchaImage::_randomTextLength
    IL_0006:  newobj     instance void [mscorlib]System.Text.StringBuilder::.ctor(int32)
    IL_000b:  stloc.0
    IL_000c:  ldarg.0
    IL_000d:  ldfld      string MSCaptcha.CaptchaImage::_randomTextChars
    IL_0012:  callvirt   instance int32 [mscorlib]System.String::get_Length()
    IL_0017:  stloc.1
    IL_0018:  ldc.i4.0
    IL_0019:  stloc.2
    IL_001a:  br.s       IL_003f

    IL_001c:  ldloc.0
    IL_001d:  ldarg.0
    IL_001e:  ldfld      string MSCaptcha.CaptchaImage::_randomTextChars
    IL_0023:  ldarg.0
    IL_0024:  ldfld      class [mscorlib]System.Random MSCaptcha.CaptchaImage::_rand
    IL_0029:  ldloc.1
    IL_002a:  callvirt   instance int32 [mscorlib]System.Random::Next(int32)
    IL_002f:  ldc.i4.1
    IL_0030:  callvirt   instance string [mscorlib]System.String::Substring(int32,
                                                                            int32)
    IL_0035:  callvirt   instance class [mscorlib]System.Text.StringBuilder [mscorlib]System.Text.StringBuilder::Append(string)
    IL_003a:  pop
    IL_003b:  ldloc.2
    IL_003c:  ldc.i4.1
    IL_003d:  add
    IL_003e:  stloc.2
    IL_003f:  ldloc.2
    IL_0040:  ldarg.0
    IL_0041:  ldfld      int32 MSCaptcha.CaptchaImage::_randomTextLength
    IL_0046:  ldc.i4.1
    IL_0047:  sub
    IL_0048:  ble.s      IL_001c

    IL_004a:  ldloc.0
    IL_004b:  callvirt   instance string [mscorlib]System.Object::ToString()
    IL_0050:  ret
  } // end of method CaptchaImage::GenerateRandomText

  .method private hidebysig instance valuetype [System.Drawing]System.Drawing.PointF 
          RandomPoint(int32 xmin,
                      int32 xmax,
                      int32 ymin,
                      int32 ymax) cil managed
  {
    // Code size       35 (0x23)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldfld      class [mscorlib]System.Random MSCaptcha.CaptchaImage::_rand
    IL_0006:  ldarg.1
    IL_0007:  ldarg.2
    IL_0008:  callvirt   instance int32 [mscorlib]System.Random::Next(int32,
                                                                      int32)
    IL_000d:  conv.r4
    IL_000e:  ldarg.0
    IL_000f:  ldfld      class [mscorlib]System.Random MSCaptcha.CaptchaImage::_rand
    IL_0014:  ldarg.3
    IL_0015:  ldarg.s    ymax
    IL_0017:  callvirt   instance int32 [mscorlib]System.Random::Next(int32,
                                                                      int32)
    IL_001c:  conv.r4
    IL_001d:  newobj     instance void [System.Drawing]System.Drawing.PointF::.ctor(float32,
                                                                                    float32)
    IL_0022:  ret
  } // end of method CaptchaImage::RandomPoint

  .method private hidebysig instance valuetype [System.Drawing]System.Drawing.PointF 
          RandomPoint(valuetype [System.Drawing]System.Drawing.Rectangle rect) cil managed
  {
    // Code size       35 (0x23)
    .maxstack  8
    IL_0000:  ldarg.0
    IL_0001:  ldarga.s   rect
    IL_0003:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Left()
    IL_0008:  ldarga.s   rect
    IL_000a:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Width()
    IL_000f:  ldarga.s   rect
    IL_0011:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Top()
    IL_0016:  ldarga.s   rect
    IL_0018:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Bottom()
    IL_001d:  call       instance valuetype [System.Drawing]System.Drawing.PointF MSCaptcha.CaptchaImage::RandomPoint(int32,
                                                                                                                      int32,
                                                                                                                      int32,
                                                                                                                      int32)
    IL_0022:  ret
  } // end of method CaptchaImage::RandomPoint

  .method private hidebysig instance class [System.Drawing]System.Drawing.Drawing2D.GraphicsPath 
          TextPath(string s,
                   class [System.Drawing]System.Drawing.Font f,
                   valuetype [System.Drawing]System.Drawing.Rectangle r) cil managed
  {
    // Code size       55 (0x37)
    .maxstack  7
    .locals init (class [System.Drawing]System.Drawing.StringFormat V_0,
             class [System.Drawing]System.Drawing.Drawing2D.GraphicsPath V_1)
    IL_0000:  newobj     instance void [System.Drawing]System.Drawing.StringFormat::.ctor()
    IL_0005:  stloc.0
    IL_0006:  ldloc.0
    IL_0007:  ldc.i4.0
    IL_0008:  callvirt   instance void [System.Drawing]System.Drawing.StringFormat::set_Alignment(valuetype [System.Drawing]System.Drawing.StringAlignment)
    IL_000d:  ldloc.0
    IL_000e:  ldc.i4.0
    IL_000f:  callvirt   instance void [System.Drawing]System.Drawing.StringFormat::set_LineAlignment(valuetype [System.Drawing]System.Drawing.StringAlignment)
    IL_0014:  newobj     instance void [System.Drawing]System.Drawing.Drawing2D.GraphicsPath::.ctor()
    IL_0019:  stloc.1
    IL_001a:  ldloc.1
    IL_001b:  ldarg.1
    IL_001c:  ldarg.2
    IL_001d:  callvirt   instance class [System.Drawing]System.Drawing.FontFamily [System.Drawing]System.Drawing.Font::get_FontFamily()
    IL_0022:  ldarg.2
    IL_0023:  callvirt   instance valuetype [System.Drawing]System.Drawing.FontStyle [System.Drawing]System.Drawing.Font::get_Style()
    IL_0028:  ldarg.2
    IL_0029:  callvirt   instance float32 [System.Drawing]System.Drawing.Font::get_Size()
    IL_002e:  ldarg.3
    IL_002f:  ldloc.0
    IL_0030:  callvirt   instance void [System.Drawing]System.Drawing.Drawing2D.GraphicsPath::AddString(string,
                                                                                                        class [System.Drawing]System.Drawing.FontFamily,
                                                                                                        int32,
                                                                                                        float32,
                                                                                                        valuetype [System.Drawing]System.Drawing.Rectangle,
                                                                                                        class [System.Drawing]System.Drawing.StringFormat)
    IL_0035:  ldloc.1
    IL_0036:  ret
  } // end of method CaptchaImage::TextPath

  .method private hidebysig instance class [System.Drawing]System.Drawing.Font 
          GetFont() cil managed
  {
    // Code size       208 (0xd0)
    .maxstack  4
    .locals init (float32 V_0,
             string V_1,
             valuetype MSCaptcha.CaptchaImage/FontWarpFactor V_2)
    IL_0000:  ldc.r4     0.0
    IL_0005:  stloc.0
    IL_0006:  ldarg.0
    IL_0007:  ldfld      string MSCaptcha.CaptchaImage::_fontFamilyName
    IL_000c:  stloc.1
    IL_000d:  ldloc.1
    IL_000e:  ldstr      ""
    IL_0013:  call       bool [mscorlib]System.String::op_Equality(string,
                                                                   string)
    IL_0018:  brfalse.s  IL_0021

    IL_001a:  ldarg.0
    IL_001b:  call       instance string MSCaptcha.CaptchaImage::RandomFontFamily()
    IL_0020:  stloc.1
    IL_0021:  ldarg.0
    IL_0022:  call       instance valuetype MSCaptcha.CaptchaImage/FontWarpFactor MSCaptcha.CaptchaImage::get_FontWarp()
    IL_0027:  stloc.2
    IL_0028:  ldloc.2
    IL_0029:  switch     ( 
                          IL_0047,
                          IL_0061,
                          IL_007b,
                          IL_0095,
                          IL_00af)
    IL_0042:  br         IL_00c7

    IL_0047:  ldarg.0
    IL_0048:  ldfld      int32 MSCaptcha.CaptchaImage::_height
    IL_004d:  conv.r8
    IL_004e:  ldc.r8     0.69999999999999996
    IL_0057:  mul
    IL_0058:  call       int32 [mscorlib]System.Convert::ToInt32(float64)
    IL_005d:  conv.r4
    IL_005e:  stloc.0
    IL_005f:  br.s       IL_00c7

    IL_0061:  ldarg.0
    IL_0062:  ldfld      int32 MSCaptcha.CaptchaImage::_height
    IL_0067:  conv.r8
    IL_0068:  ldc.r8     0.80000000000000004
    IL_0071:  mul
    IL_0072:  call       int32 [mscorlib]System.Convert::ToInt32(float64)
    IL_0077:  conv.r4
    IL_0078:  stloc.0
    IL_0079:  br.s       IL_00c7

    IL_007b:  ldarg.0
    IL_007c:  ldfld      int32 MSCaptcha.CaptchaImage::_height
    IL_0081:  conv.r8
    IL_0082:  ldc.r8     0.84999999999999998
    IL_008b:  mul
    IL_008c:  call       int32 [mscorlib]System.Convert::ToInt32(float64)
    IL_0091:  conv.r4
    IL_0092:  stloc.0
    IL_0093:  br.s       IL_00c7

    IL_0095:  ldarg.0
    IL_0096:  ldfld      int32 MSCaptcha.CaptchaImage::_height
    IL_009b:  conv.r8
    IL_009c:  ldc.r8     0.90000000000000002
    IL_00a5:  mul
    IL_00a6:  call       int32 [mscorlib]System.Convert::ToInt32(float64)
    IL_00ab:  conv.r4
    IL_00ac:  stloc.0
    IL_00ad:  br.s       IL_00c7

    IL_00af:  ldarg.0
    IL_00b0:  ldfld      int32 MSCaptcha.CaptchaImage::_height
    IL_00b5:  conv.r8
    IL_00b6:  ldc.r8     0.94999999999999996
    IL_00bf:  mul
    IL_00c0:  call       int32 [mscorlib]System.Convert::ToInt32(float64)
    IL_00c5:  conv.r4
    IL_00c6:  stloc.0
    IL_00c7:  ldloc.1
    IL_00c8:  ldloc.0
    IL_00c9:  ldc.i4.1
    IL_00ca:  newobj     instance void [System.Drawing]System.Drawing.Font::.ctor(string,
                                                                                  float32,
                                                                                  valuetype [System.Drawing]System.Drawing.FontStyle)
    IL_00cf:  ret
  } // end of method CaptchaImage::GetFont

  .method private hidebysig instance class [System.Drawing]System.Drawing.Bitmap 
          GenerateImagePrivate() cil managed
  {
    // Code size       342 (0x156)
    .maxstack  5
    .locals init (class [System.Drawing]System.Drawing.Font V_0,
             valuetype [System.Drawing]System.Drawing.Rectangle V_1,
             class [System.Drawing]System.Drawing.Brush V_2,
             class [System.Drawing]System.Drawing.Bitmap V_3,
             class [System.Drawing]System.Drawing.Graphics V_4,
             int32 V_5,
             float64 V_6,
             valuetype [System.Drawing]System.Drawing.Rectangle V_7,
             char V_8,
             class [System.Drawing]System.Drawing.Drawing2D.GraphicsPath V_9,
             class [System.Drawing]System.Drawing.Brush V_10,
             class [System.Drawing]System.Drawing.Brush V_11,
             string V_12,
             int32 V_13,
             class [System.Drawing]System.Drawing.Font V_14)
    IL_0000:  ldnull
    IL_0001:  stloc.0
    IL_0002:  ldarg.0
    IL_0003:  ldfld      int32 MSCaptcha.CaptchaImage::_width
    IL_0008:  ldarg.0
    IL_0009:  ldfld      int32 MSCaptcha.CaptchaImage::_height
    IL_000e:  ldc.i4     0x26200a
    IL_0013:  newobj     instance void [System.Drawing]System.Drawing.Bitmap::.ctor(int32,
                                                                                    int32,
                                                                                    valuetype [System.Drawing]System.Drawing.Imaging.PixelFormat)
    IL_0018:  stloc.3
    IL_0019:  ldloc.3
    IL_001a:  call       class [System.Drawing]System.Drawing.Graphics [System.Drawing]System.Drawing.Graphics::FromImage(class [System.Drawing]System.Drawing.Image)
    IL_001f:  stloc.s    V_4
    .try
    {
      IL_0021:  ldloc.s    V_4
      IL_0023:  ldc.i4.4
      IL_0024:  callvirt   instance void [System.Drawing]System.Drawing.Graphics::set_SmoothingMode(valuetype [System.Drawing]System.Drawing.Drawing2D.SmoothingMode)
      IL_0029:  ldc.i4.0
      IL_002a:  ldc.i4.0
      IL_002b:  ldarg.0
      IL_002c:  ldfld      int32 MSCaptcha.CaptchaImage::_width
      IL_0031:  ldarg.0
      IL_0032:  ldfld      int32 MSCaptcha.CaptchaImage::_height
      IL_0037:  newobj     instance void [System.Drawing]System.Drawing.Rectangle::.ctor(int32,
                                                                                         int32,
                                                                                         int32,
                                                                                         int32)
      IL_003c:  stloc.1
      IL_003d:  ldarg.0
      IL_003e:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_backColor
      IL_0043:  newobj     instance void [System.Drawing]System.Drawing.SolidBrush::.ctor(valuetype [System.Drawing]System.Drawing.Color)
      IL_0048:  dup
      IL_0049:  stloc.2
      IL_004a:  stloc.s    V_10
      .try
      {
        IL_004c:  ldloc.s    V_4
        IL_004e:  ldloc.2
        IL_004f:  ldloc.1
        IL_0050:  callvirt   instance void [System.Drawing]System.Drawing.Graphics::FillRectangle(class [System.Drawing]System.Drawing.Brush,
                                                                                                  valuetype [System.Drawing]System.Drawing.Rectangle)
        IL_0055:  leave.s    IL_0063

      }  // end .try
      finally
      {
        IL_0057:  ldloc.s    V_10
        IL_0059:  brfalse.s  IL_0062

        IL_005b:  ldloc.s    V_10
        IL_005d:  callvirt   instance void [mscorlib]System.IDisposable::Dispose()
        IL_0062:  endfinally
      }  // end handler
      IL_0063:  ldc.i4.0
      IL_0064:  stloc.s    V_5
      IL_0066:  ldarg.0
      IL_0067:  ldfld      int32 MSCaptcha.CaptchaImage::_width
      IL_006c:  ldarg.0
      IL_006d:  ldfld      int32 MSCaptcha.CaptchaImage::_randomTextLength
      IL_0072:  div
      IL_0073:  conv.r8
      IL_0074:  stloc.s    V_6
      IL_0076:  ldarg.0
      IL_0077:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_fontColor
      IL_007c:  newobj     instance void [System.Drawing]System.Drawing.SolidBrush::.ctor(valuetype [System.Drawing]System.Drawing.Color)
      IL_0081:  dup
      IL_0082:  stloc.2
      IL_0083:  stloc.s    V_11
      .try
      {
        IL_0085:  ldarg.0
        IL_0086:  ldfld      string MSCaptcha.CaptchaImage::_randomText
        IL_008b:  stloc.s    V_12
        IL_008d:  ldc.i4.0
        IL_008e:  stloc.s    V_13
        IL_0090:  br         IL_0118

        IL_0095:  ldloc.s    V_12
        IL_0097:  ldloc.s    V_13
        IL_0099:  callvirt   instance char [mscorlib]System.String::get_Chars(int32)
        IL_009e:  stloc.s    V_8
        IL_00a0:  ldarg.0
        IL_00a1:  call       instance class [System.Drawing]System.Drawing.Font MSCaptcha.CaptchaImage::GetFont()
        IL_00a6:  dup
        IL_00a7:  stloc.0
        IL_00a8:  stloc.s    V_14
        .try
        {
          IL_00aa:  ldloc.s    V_5
          IL_00ac:  conv.r8
          IL_00ad:  ldloc.s    V_6
          IL_00af:  mul
          IL_00b0:  call       int32 [mscorlib]System.Convert::ToInt32(float64)
          IL_00b5:  ldc.i4.0
          IL_00b6:  ldloc.s    V_6
          IL_00b8:  call       int32 [mscorlib]System.Convert::ToInt32(float64)
          IL_00bd:  ldarg.0
          IL_00be:  ldfld      int32 MSCaptcha.CaptchaImage::_height
          IL_00c3:  newobj     instance void [System.Drawing]System.Drawing.Rectangle::.ctor(int32,
                                                                                             int32,
                                                                                             int32,
                                                                                             int32)
          IL_00c8:  stloc.s    V_7
          IL_00ca:  ldarg.0
          IL_00cb:  ldloca.s   V_8
          IL_00cd:  call       instance string [mscorlib]System.Char::ToString()
          IL_00d2:  ldloc.0
          IL_00d3:  ldloc.s    V_7
          IL_00d5:  call       instance class [System.Drawing]System.Drawing.Drawing2D.GraphicsPath MSCaptcha.CaptchaImage::TextPath(string,
                                                                                                                                     class [System.Drawing]System.Drawing.Font,
                                                                                                                                     valuetype [System.Drawing]System.Drawing.Rectangle)
          IL_00da:  stloc.s    V_9
          .try
          {
            IL_00dc:  ldarg.0
            IL_00dd:  ldloc.s    V_9
            IL_00df:  ldloc.s    V_7
            IL_00e1:  call       instance void MSCaptcha.CaptchaImage::WarpText(class [System.Drawing]System.Drawing.Drawing2D.GraphicsPath,
                                                                                valuetype [System.Drawing]System.Drawing.Rectangle)
            IL_00e6:  ldloc.s    V_4
            IL_00e8:  ldloc.2
            IL_00e9:  ldloc.s    V_9
            IL_00eb:  callvirt   instance void [System.Drawing]System.Drawing.Graphics::FillPath(class [System.Drawing]System.Drawing.Brush,
                                                                                                 class [System.Drawing]System.Drawing.Drawing2D.GraphicsPath)
            IL_00f0:  leave.s    IL_00fe

          }  // end .try
          finally
          {
            IL_00f2:  ldloc.s    V_9
            IL_00f4:  brfalse.s  IL_00fd

            IL_00f6:  ldloc.s    V_9
            IL_00f8:  callvirt   instance void [mscorlib]System.IDisposable::Dispose()
            IL_00fd:  endfinally
          }  // end handler
          IL_00fe:  leave.s    IL_010c

        }  // end .try
        finally
        {
          IL_0100:  ldloc.s    V_14
          IL_0102:  brfalse.s  IL_010b

          IL_0104:  ldloc.s    V_14
          IL_0106:  callvirt   instance void [mscorlib]System.IDisposable::Dispose()
          IL_010b:  endfinally
        }  // end handler
        IL_010c:  ldloc.s    V_5
        IL_010e:  ldc.i4.1
        IL_010f:  add
        IL_0110:  stloc.s    V_5
        IL_0112:  ldloc.s    V_13
        IL_0114:  ldc.i4.1
        IL_0115:  add
        IL_0116:  stloc.s    V_13
        IL_0118:  ldloc.s    V_13
        IL_011a:  ldloc.s    V_12
        IL_011c:  callvirt   instance int32 [mscorlib]System.String::get_Length()
        IL_0121:  blt        IL_0095

        IL_0126:  leave.s    IL_0134

      }  // end .try
      finally
      {
        IL_0128:  ldloc.s    V_11
        IL_012a:  brfalse.s  IL_0133

        IL_012c:  ldloc.s    V_11
        IL_012e:  callvirt   instance void [mscorlib]System.IDisposable::Dispose()
        IL_0133:  endfinally
      }  // end handler
      IL_0134:  ldarg.0
      IL_0135:  ldloc.s    V_4
      IL_0137:  ldloc.1
      IL_0138:  call       instance void MSCaptcha.CaptchaImage::AddNoise(class [System.Drawing]System.Drawing.Graphics,
                                                                          valuetype [System.Drawing]System.Drawing.Rectangle)
      IL_013d:  ldarg.0
      IL_013e:  ldloc.s    V_4
      IL_0140:  ldloc.1
      IL_0141:  call       instance void MSCaptcha.CaptchaImage::AddLine(class [System.Drawing]System.Drawing.Graphics,
                                                                         valuetype [System.Drawing]System.Drawing.Rectangle)
      IL_0146:  leave.s    IL_0154

    }  // end .try
    finally
    {
      IL_0148:  ldloc.s    V_4
      IL_014a:  brfalse.s  IL_0153

      IL_014c:  ldloc.s    V_4
      IL_014e:  callvirt   instance void [mscorlib]System.IDisposable::Dispose()
      IL_0153:  endfinally
    }  // end handler
    IL_0154:  ldloc.3
    IL_0155:  ret
  } // end of method CaptchaImage::GenerateImagePrivate

  .method private hidebysig instance void 
          WarpText(class [System.Drawing]System.Drawing.Drawing2D.GraphicsPath textPath,
                   valuetype [System.Drawing]System.Drawing.Rectangle rect) cil managed
  {
    // Code size       525 (0x20d)
    .maxstack  6
    .locals init (float32 V_0,
             float32 V_1,
             valuetype [System.Drawing]System.Drawing.RectangleF V_2,
             int32 V_3,
             int32 V_4,
             int32 V_5,
             int32 V_6,
             int32 V_7,
             int32 V_8,
             valuetype [System.Drawing]System.Drawing.PointF V_9,
             valuetype [System.Drawing]System.Drawing.PointF V_10,
             valuetype [System.Drawing]System.Drawing.PointF V_11,
             valuetype [System.Drawing]System.Drawing.PointF V_12,
             valuetype [System.Drawing]System.Drawing.PointF[] V_13,
             class [System.Drawing]System.Drawing.Drawing2D.Matrix V_14,
             valuetype MSCaptcha.CaptchaImage/FontWarpFactor V_15,
             valuetype [System.Drawing]System.Drawing.PointF[] V_16)
    IL_0000:  ldc.r4     1.
    IL_0005:  stloc.0
    IL_0006:  ldc.r4     1.
    IL_000b:  stloc.1
    IL_000c:  ldarg.0
    IL_000d:  ldfld      valuetype MSCaptcha.CaptchaImage/FontWarpFactor MSCaptcha.CaptchaImage::_fontWarp
    IL_0012:  stloc.s    V_15
    IL_0014:  ldloc.s    V_15
    IL_0016:  switch     ( 
                          IL_0031,
                          IL_0032,
                          IL_0040,
                          IL_004e,
                          IL_005c)
    IL_002f:  br.s       IL_0068

    IL_0031:  ret

    IL_0032:  ldc.r4     6.
    IL_0037:  stloc.0
    IL_0038:  ldc.r4     1.
    IL_003d:  stloc.1
    IL_003e:  br.s       IL_0068

    IL_0040:  ldc.r4     5.
    IL_0045:  stloc.0
    IL_0046:  ldc.r4     1.3
    IL_004b:  stloc.1
    IL_004c:  br.s       IL_0068

    IL_004e:  ldc.r4     4.5
    IL_0053:  stloc.0
    IL_0054:  ldc.r4     1.4
    IL_0059:  stloc.1
    IL_005a:  br.s       IL_0068

    IL_005c:  ldc.r4     4.
    IL_0061:  stloc.0
    IL_0062:  ldc.r4     1.5
    IL_0067:  stloc.1
    IL_0068:  ldloca.s   V_2
    IL_006a:  ldarga.s   rect
    IL_006c:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Left()
    IL_0071:  call       float32 [mscorlib]System.Convert::ToSingle(int32)
    IL_0076:  ldc.r4     0.0
    IL_007b:  ldarga.s   rect
    IL_007d:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Width()
    IL_0082:  call       float32 [mscorlib]System.Convert::ToSingle(int32)
    IL_0087:  ldarga.s   rect
    IL_0089:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Height()
    IL_008e:  conv.r4
    IL_008f:  call       instance void [System.Drawing]System.Drawing.RectangleF::.ctor(float32,
                                                                                        float32,
                                                                                        float32,
                                                                                        float32)
    IL_0094:  ldarga.s   rect
    IL_0096:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Height()
    IL_009b:  conv.r4
    IL_009c:  ldloc.0
    IL_009d:  div
    IL_009e:  call       int32 [mscorlib]System.Convert::ToInt32(float32)
    IL_00a3:  stloc.3
    IL_00a4:  ldarga.s   rect
    IL_00a6:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Width()
    IL_00ab:  conv.r4
    IL_00ac:  ldloc.0
    IL_00ad:  div
    IL_00ae:  call       int32 [mscorlib]System.Convert::ToInt32(float32)
    IL_00b3:  stloc.s    V_4
    IL_00b5:  ldarga.s   rect
    IL_00b7:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Left()
    IL_00bc:  ldloc.s    V_4
    IL_00be:  conv.r4
    IL_00bf:  ldloc.1
    IL_00c0:  mul
    IL_00c1:  call       int32 [mscorlib]System.Convert::ToInt32(float32)
    IL_00c6:  sub
    IL_00c7:  stloc.s    V_5
    IL_00c9:  ldarga.s   rect
    IL_00cb:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Top()
    IL_00d0:  ldloc.3
    IL_00d1:  conv.r4
    IL_00d2:  ldloc.1
    IL_00d3:  mul
    IL_00d4:  call       int32 [mscorlib]System.Convert::ToInt32(float32)
    IL_00d9:  sub
    IL_00da:  stloc.s    V_6
    IL_00dc:  ldarga.s   rect
    IL_00de:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Left()
    IL_00e3:  ldarga.s   rect
    IL_00e5:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Width()
    IL_00ea:  add
    IL_00eb:  ldloc.s    V_4
    IL_00ed:  conv.r4
    IL_00ee:  ldloc.1
    IL_00ef:  mul
    IL_00f0:  call       int32 [mscorlib]System.Convert::ToInt32(float32)
    IL_00f5:  add
    IL_00f6:  stloc.s    V_7
    IL_00f8:  ldarga.s   rect
    IL_00fa:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Top()
    IL_00ff:  ldarga.s   rect
    IL_0101:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Height()
    IL_0106:  add
    IL_0107:  ldloc.3
    IL_0108:  conv.r4
    IL_0109:  ldloc.1
    IL_010a:  mul
    IL_010b:  call       int32 [mscorlib]System.Convert::ToInt32(float32)
    IL_0110:  add
    IL_0111:  stloc.s    V_8
    IL_0113:  ldloc.s    V_5
    IL_0115:  ldc.i4.0
    IL_0116:  bge.s      IL_011b

    IL_0118:  ldc.i4.0
    IL_0119:  stloc.s    V_5
    IL_011b:  ldloc.s    V_6
    IL_011d:  ldc.i4.0
    IL_011e:  bge.s      IL_0123

    IL_0120:  ldc.i4.0
    IL_0121:  stloc.s    V_6
    IL_0123:  ldloc.s    V_7
    IL_0125:  ldarg.0
    IL_0126:  call       instance int32 MSCaptcha.CaptchaImage::get_Width()
    IL_012b:  ble.s      IL_0135

    IL_012d:  ldarg.0
    IL_012e:  call       instance int32 MSCaptcha.CaptchaImage::get_Width()
    IL_0133:  stloc.s    V_7
    IL_0135:  ldloc.s    V_8
    IL_0137:  ldarg.0
    IL_0138:  call       instance int32 MSCaptcha.CaptchaImage::get_Height()
    IL_013d:  ble.s      IL_0147

    IL_013f:  ldarg.0
    IL_0140:  call       instance int32 MSCaptcha.CaptchaImage::get_Height()
    IL_0145:  stloc.s    V_8
    IL_0147:  ldarg.0
    IL_0148:  ldloc.s    V_5
    IL_014a:  ldloc.s    V_5
    IL_014c:  ldloc.s    V_4
    IL_014e:  add
    IL_014f:  ldloc.s    V_6
    IL_0151:  ldloc.s    V_6
    IL_0153:  ldloc.3
    IL_0154:  add
    IL_0155:  call       instance valuetype [System.Drawing]System.Drawing.PointF MSCaptcha.CaptchaImage::RandomPoint(int32,
                                                                                                                      int32,
                                                                                                                      int32,
                                                                                                                      int32)
    IL_015a:  stloc.s    V_9
    IL_015c:  ldarg.0
    IL_015d:  ldloc.s    V_7
    IL_015f:  ldloc.s    V_4
    IL_0161:  sub
    IL_0162:  ldloc.s    V_7
    IL_0164:  ldloc.s    V_6
    IL_0166:  ldloc.s    V_6
    IL_0168:  ldloc.3
    IL_0169:  add
    IL_016a:  call       instance valuetype [System.Drawing]System.Drawing.PointF MSCaptcha.CaptchaImage::RandomPoint(int32,
                                                                                                                      int32,
                                                                                                                      int32,
                                                                                                                      int32)
    IL_016f:  stloc.s    V_10
    IL_0171:  ldarg.0
    IL_0172:  ldloc.s    V_5
    IL_0174:  ldloc.s    V_5
    IL_0176:  ldloc.s    V_4
    IL_0178:  add
    IL_0179:  ldloc.s    V_8
    IL_017b:  ldloc.3
    IL_017c:  sub
    IL_017d:  ldloc.s    V_8
    IL_017f:  call       instance valuetype [System.Drawing]System.Drawing.PointF MSCaptcha.CaptchaImage::RandomPoint(int32,
                                                                                                                      int32,
                                                                                                                      int32,
                                                                                                                      int32)
    IL_0184:  stloc.s    V_11
    IL_0186:  ldarg.0
    IL_0187:  ldloc.s    V_7
    IL_0189:  ldloc.s    V_4
    IL_018b:  sub
    IL_018c:  ldloc.s    V_7
    IL_018e:  ldloc.s    V_8
    IL_0190:  ldloc.3
    IL_0191:  sub
    IL_0192:  ldloc.s    V_8
    IL_0194:  call       instance valuetype [System.Drawing]System.Drawing.PointF MSCaptcha.CaptchaImage::RandomPoint(int32,
                                                                                                                      int32,
                                                                                                                      int32,
                                                                                                                      int32)
    IL_0199:  stloc.s    V_12
    IL_019b:  ldc.i4.4
    IL_019c:  newarr     [System.Drawing]System.Drawing.PointF
    IL_01a1:  stloc.s    V_16
    IL_01a3:  ldloc.s    V_16
    IL_01a5:  ldc.i4.0
    IL_01a6:  ldelema    [System.Drawing]System.Drawing.PointF
    IL_01ab:  ldloc.s    V_9
    IL_01ad:  stobj      [System.Drawing]System.Drawing.PointF
    IL_01b2:  ldloc.s    V_16
    IL_01b4:  ldc.i4.1
    IL_01b5:  ldelema    [System.Drawing]System.Drawing.PointF
    IL_01ba:  ldloc.s    V_10
    IL_01bc:  stobj      [System.Drawing]System.Drawing.PointF
    IL_01c1:  ldloc.s    V_16
    IL_01c3:  ldc.i4.2
    IL_01c4:  ldelema    [System.Drawing]System.Drawing.PointF
    IL_01c9:  ldloc.s    V_11
    IL_01cb:  stobj      [System.Drawing]System.Drawing.PointF
    IL_01d0:  ldloc.s    V_16
    IL_01d2:  ldc.i4.3
    IL_01d3:  ldelema    [System.Drawing]System.Drawing.PointF
    IL_01d8:  ldloc.s    V_12
    IL_01da:  stobj      [System.Drawing]System.Drawing.PointF
    IL_01df:  ldloc.s    V_16
    IL_01e1:  stloc.s    V_13
    IL_01e3:  newobj     instance void [System.Drawing]System.Drawing.Drawing2D.Matrix::.ctor()
    IL_01e8:  stloc.s    V_14
    IL_01ea:  ldloc.s    V_14
    IL_01ec:  ldc.r4     0.0
    IL_01f1:  ldc.r4     0.0
    IL_01f6:  callvirt   instance void [System.Drawing]System.Drawing.Drawing2D.Matrix::Translate(float32,
                                                                                                  float32)
    IL_01fb:  ldarg.1
    IL_01fc:  ldloc.s    V_13
    IL_01fe:  ldloc.2
    IL_01ff:  ldloc.s    V_14
    IL_0201:  ldc.i4.0
    IL_0202:  ldc.r4     0.0
    IL_0207:  callvirt   instance void [System.Drawing]System.Drawing.Drawing2D.GraphicsPath::Warp(valuetype [System.Drawing]System.Drawing.PointF[],
                                                                                                   valuetype [System.Drawing]System.Drawing.RectangleF,
                                                                                                   class [System.Drawing]System.Drawing.Drawing2D.Matrix,
                                                                                                   valuetype [System.Drawing]System.Drawing.Drawing2D.WarpMode,
                                                                                                   float32)
    IL_020c:  ret
  } // end of method CaptchaImage::WarpText

  .method private hidebysig instance void 
          AddNoise(class [System.Drawing]System.Drawing.Graphics graphics1,
                   valuetype [System.Drawing]System.Drawing.Rectangle rect) cil managed
  {
    // Code size       228 (0xe4)
    .maxstack  7
    .locals init (int32 V_0,
             int32 V_1,
             class [System.Drawing]System.Drawing.SolidBrush V_2,
             int32 V_3,
             int32 V_4,
             valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel V_5)
    IL_0000:  ldc.i4.0
    IL_0001:  stloc.0
    IL_0002:  ldc.i4.0
    IL_0003:  stloc.1
    IL_0004:  ldarg.0
    IL_0005:  ldfld      valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel MSCaptcha.CaptchaImage::_backgroundNoise
    IL_000a:  stloc.s    V_5
    IL_000c:  ldloc.s    V_5
    IL_000e:  switch     ( 
                          IL_0029,
                          IL_002a,
                          IL_0032,
                          IL_003a,
                          IL_0042)
    IL_0027:  br.s       IL_0048

    IL_0029:  ret

    IL_002a:  ldc.i4.s   30
    IL_002c:  stloc.0
    IL_002d:  ldc.i4.s   40
    IL_002f:  stloc.1
    IL_0030:  br.s       IL_0048

    IL_0032:  ldc.i4.s   18
    IL_0034:  stloc.0
    IL_0035:  ldc.i4.s   40
    IL_0037:  stloc.1
    IL_0038:  br.s       IL_0048

    IL_003a:  ldc.i4.s   16
    IL_003c:  stloc.0
    IL_003d:  ldc.i4.s   39
    IL_003f:  stloc.1
    IL_0040:  br.s       IL_0048

    IL_0042:  ldc.i4.s   12
    IL_0044:  stloc.0
    IL_0045:  ldc.i4.s   38
    IL_0047:  stloc.1
    IL_0048:  ldarg.0
    IL_0049:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_noiseColor
    IL_004e:  newobj     instance void [System.Drawing]System.Drawing.SolidBrush::.ctor(valuetype [System.Drawing]System.Drawing.Color)
    IL_0053:  stloc.2
    .try
    {
      IL_0054:  ldarga.s   rect
      IL_0056:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Width()
      IL_005b:  ldarga.s   rect
      IL_005d:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Height()
      IL_0062:  call       int32 [mscorlib]System.Math::Max(int32,
                                                            int32)
      IL_0067:  ldloc.1
      IL_0068:  div
      IL_0069:  call       int32 [mscorlib]System.Convert::ToInt32(int32)
      IL_006e:  stloc.3
      IL_006f:  ldc.i4.0
      IL_0070:  stloc.s    V_4
      IL_0072:  br.s       IL_00bd

      IL_0074:  ldarg.1
      IL_0075:  ldloc.2
      IL_0076:  ldarg.0
      IL_0077:  ldfld      class [mscorlib]System.Random MSCaptcha.CaptchaImage::_rand
      IL_007c:  ldarga.s   rect
      IL_007e:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Width()
      IL_0083:  callvirt   instance int32 [mscorlib]System.Random::Next(int32)
      IL_0088:  ldarg.0
      IL_0089:  ldfld      class [mscorlib]System.Random MSCaptcha.CaptchaImage::_rand
      IL_008e:  ldarga.s   rect
      IL_0090:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Height()
      IL_0095:  callvirt   instance int32 [mscorlib]System.Random::Next(int32)
      IL_009a:  ldarg.0
      IL_009b:  ldfld      class [mscorlib]System.Random MSCaptcha.CaptchaImage::_rand
      IL_00a0:  ldloc.3
      IL_00a1:  callvirt   instance int32 [mscorlib]System.Random::Next(int32)
      IL_00a6:  ldarg.0
      IL_00a7:  ldfld      class [mscorlib]System.Random MSCaptcha.CaptchaImage::_rand
      IL_00ac:  ldloc.3
      IL_00ad:  callvirt   instance int32 [mscorlib]System.Random::Next(int32)
      IL_00b2:  callvirt   instance void [System.Drawing]System.Drawing.Graphics::FillEllipse(class [System.Drawing]System.Drawing.Brush,
                                                                                              int32,
                                                                                              int32,
                                                                                              int32,
                                                                                              int32)
      IL_00b7:  ldloc.s    V_4
      IL_00b9:  ldc.i4.1
      IL_00ba:  add
      IL_00bb:  stloc.s    V_4
      IL_00bd:  ldloc.s    V_4
      IL_00bf:  ldarga.s   rect
      IL_00c1:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Width()
      IL_00c6:  ldarga.s   rect
      IL_00c8:  call       instance int32 [System.Drawing]System.Drawing.Rectangle::get_Height()
      IL_00cd:  mul
      IL_00ce:  ldloc.0
      IL_00cf:  div
      IL_00d0:  call       int32 [mscorlib]System.Convert::ToInt32(int32)
      IL_00d5:  ble.s      IL_0074

      IL_00d7:  leave.s    IL_00e3

    }  // end .try
    finally
    {
      IL_00d9:  ldloc.2
      IL_00da:  brfalse.s  IL_00e2

      IL_00dc:  ldloc.2
      IL_00dd:  callvirt   instance void [mscorlib]System.IDisposable::Dispose()
      IL_00e2:  endfinally
    }  // end handler
    IL_00e3:  ret
  } // end of method CaptchaImage::AddNoise

  .method private hidebysig instance void 
          AddLine(class [System.Drawing]System.Drawing.Graphics graphics1,
                  valuetype [System.Drawing]System.Drawing.Rectangle rect) cil managed
  {
    // Code size       258 (0x102)
    .maxstack  4
    .locals init (int32 V_0,
             float32 V_1,
             int32 V_2,
             valuetype [System.Drawing]System.Drawing.PointF[] V_3,
             class [System.Drawing]System.Drawing.Pen V_4,
             int32 V_5,
             int32 V_6,
             valuetype MSCaptcha.CaptchaImage/LineNoiseLevel V_7)
    IL_0000:  ldc.i4.0
    IL_0001:  stloc.0
    IL_0002:  ldc.r4     1.
    IL_0007:  stloc.1
    IL_0008:  ldc.i4.0
    IL_0009:  stloc.2
    IL_000a:  ldarg.0
    IL_000b:  ldfld      valuetype MSCaptcha.CaptchaImage/LineNoiseLevel MSCaptcha.CaptchaImage::_lineNoise
    IL_0010:  stloc.s    V_7
    IL_0012:  ldloc.s    V_7
    IL_0014:  switch     ( 
                          IL_002f,
                          IL_0030,
                          IL_004d,
                          IL_006a,
                          IL_007f)
    IL_002d:  br.s       IL_009a

    IL_002f:  ret

    IL_0030:  ldc.i4.4
    IL_0031:  stloc.0
    IL_0032:  ldarg.0
    IL_0033:  ldfld      int32 MSCaptcha.CaptchaImage::_height
    IL_0038:  conv.r8
    IL_0039:  ldc.r8     31.25
    IL_0042:  div
    IL_0043:  call       float32 [mscorlib]System.Convert::ToSingle(float64)
    IL_0048:  stloc.1
    IL_0049:  ldc.i4.1
    IL_004a:  stloc.2
    IL_004b:  br.s       IL_009a

    IL_004d:  ldc.i4.5
    IL_004e:  stloc.0
    IL_004f:  ldarg.0
    IL_0050:  ldfld      int32 MSCaptcha.CaptchaImage::_height
    IL_0055:  conv.r8
    IL_0056:  ldc.r8     27.777699999999999
    IL_005f:  div
    IL_0060:  call       float32 [mscorlib]System.Convert::ToSingle(float64)
    IL_0065:  stloc.1
    IL_0066:  ldc.i4.1
    IL_0067:  stloc.2
    IL_0068:  br.s       IL_009a

    IL_006a:  ldc.i4.3
    IL_006b:  stloc.0
    IL_006c:  ldarg.0
    IL_006d:  ldfld      int32 MSCaptcha.CaptchaImage::_height
    IL_0072:  ldc.i4.s   25
    IL_0074:  div
    IL_0075:  call       float32 [mscorlib]System.Convert::ToSingle(int32)
    IL_007a:  stloc.1
    IL_007b:  ldc.i4.2
    IL_007c:  stloc.2
    IL_007d:  br.s       IL_009a

    IL_007f:  ldc.i4.3
    IL_0080:  stloc.0
    IL_0081:  ldarg.0
    IL_0082:  ldfld      int32 MSCaptcha.CaptchaImage::_height
    IL_0087:  conv.r8
    IL_0088:  ldc.r8     22.7272
    IL_0091:  div
    IL_0092:  call       float32 [mscorlib]System.Convert::ToSingle(float64)
    IL_0097:  stloc.1
    IL_0098:  ldc.i4.3
    IL_0099:  stloc.2
    IL_009a:  ldloc.0
    IL_009b:  ldc.i4.1
    IL_009c:  add
    IL_009d:  newarr     [System.Drawing]System.Drawing.PointF
    IL_00a2:  stloc.3
    IL_00a3:  ldarg.0
    IL_00a4:  ldfld      valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::_lineColor
    IL_00a9:  ldloc.1
    IL_00aa:  newobj     instance void [System.Drawing]System.Drawing.Pen::.ctor(valuetype [System.Drawing]System.Drawing.Color,
                                                                                 float32)
    IL_00af:  stloc.s    V_4
    .try
    {
      IL_00b1:  ldc.i4.1
      IL_00b2:  stloc.s    V_5
      IL_00b4:  br.s       IL_00ee

      IL_00b6:  ldc.i4.0
      IL_00b7:  stloc.s    V_6
      IL_00b9:  br.s       IL_00d5

      IL_00bb:  ldloc.3
      IL_00bc:  ldloc.s    V_6
      IL_00be:  ldelema    [System.Drawing]System.Drawing.PointF
      IL_00c3:  ldarg.0
      IL_00c4:  ldarg.2
      IL_00c5:  call       instance valuetype [System.Drawing]System.Drawing.PointF MSCaptcha.CaptchaImage::RandomPoint(valuetype [System.Drawing]System.Drawing.Rectangle)
      IL_00ca:  stobj      [System.Drawing]System.Drawing.PointF
      IL_00cf:  ldloc.s    V_6
      IL_00d1:  ldc.i4.1
      IL_00d2:  add
      IL_00d3:  stloc.s    V_6
      IL_00d5:  ldloc.s    V_6
      IL_00d7:  ldloc.0
      IL_00d8:  ble.s      IL_00bb

      IL_00da:  ldarg.1
      IL_00db:  ldloc.s    V_4
      IL_00dd:  ldloc.3
      IL_00de:  ldc.r4     1.75
      IL_00e3:  callvirt   instance void [System.Drawing]System.Drawing.Graphics::DrawCurve(class [System.Drawing]System.Drawing.Pen,
                                                                                            valuetype [System.Drawing]System.Drawing.PointF[],
                                                                                            float32)
      IL_00e8:  ldloc.s    V_5
      IL_00ea:  ldc.i4.1
      IL_00eb:  add
      IL_00ec:  stloc.s    V_5
      IL_00ee:  ldloc.s    V_5
      IL_00f0:  ldloc.2
      IL_00f1:  ble.s      IL_00b6

      IL_00f3:  leave.s    IL_0101

    }  // end .try
    finally
    {
      IL_00f5:  ldloc.s    V_4
      IL_00f7:  brfalse.s  IL_0100

      IL_00f9:  ldloc.s    V_4
      IL_00fb:  callvirt   instance void [mscorlib]System.IDisposable::Dispose()
      IL_0100:  endfinally
    }  // end handler
    IL_0101:  ret
  } // end of method CaptchaImage::AddLine

  .property instance string UniqueId()
  {
    .get instance string MSCaptcha.CaptchaImage::get_UniqueId()
  } // end of property CaptchaImage::UniqueId
  .property instance valuetype [mscorlib]System.DateTime
          RenderedAt()
  {
    .get instance valuetype [mscorlib]System.DateTime MSCaptcha.CaptchaImage::get_RenderedAt()
  } // end of property CaptchaImage::RenderedAt
  .property instance string Font()
  {
    .get instance string MSCaptcha.CaptchaImage::get_Font()
    .set instance void MSCaptcha.CaptchaImage::set_Font(string)
  } // end of property CaptchaImage::Font
  .property instance valuetype MSCaptcha.CaptchaImage/FontWarpFactor
          FontWarp()
  {
    .set instance void MSCaptcha.CaptchaImage::set_FontWarp(valuetype MSCaptcha.CaptchaImage/FontWarpFactor)
    .get instance valuetype MSCaptcha.CaptchaImage/FontWarpFactor MSCaptcha.CaptchaImage::get_FontWarp()
  } // end of property CaptchaImage::FontWarp
  .property instance valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel
          BackgroundNoise()
  {
    .set instance void MSCaptcha.CaptchaImage::set_BackgroundNoise(valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel)
    .get instance valuetype MSCaptcha.CaptchaImage/BackgroundNoiseLevel MSCaptcha.CaptchaImage::get_BackgroundNoise()
  } // end of property CaptchaImage::BackgroundNoise
  .property instance valuetype MSCaptcha.CaptchaImage/LineNoiseLevel
          LineNoise()
  {
    .get instance valuetype MSCaptcha.CaptchaImage/LineNoiseLevel MSCaptcha.CaptchaImage::get_LineNoise()
    .set instance void MSCaptcha.CaptchaImage::set_LineNoise(valuetype MSCaptcha.CaptchaImage/LineNoiseLevel)
  } // end of property CaptchaImage::LineNoise
  .property instance string TextChars()
  {
    .get instance string MSCaptcha.CaptchaImage::get_TextChars()
    .set instance void MSCaptcha.CaptchaImage::set_TextChars(string)
  } // end of property CaptchaImage::TextChars
  .property instance int32 TextLength()
  {
    .get instance int32 MSCaptcha.CaptchaImage::get_TextLength()
    .set instance void MSCaptcha.CaptchaImage::set_TextLength(int32)
  } // end of property CaptchaImage::TextLength
  .property instance string Text()
  {
    .get instance string MSCaptcha.CaptchaImage::get_Text()
  } // end of property CaptchaImage::Text
  .property instance int32 Width()
  {
    .get instance int32 MSCaptcha.CaptchaImage::get_Width()
    .set instance void MSCaptcha.CaptchaImage::set_Width(int32)
  } // end of property CaptchaImage::Width
  .property instance int32 Height()
  {
    .get instance int32 MSCaptcha.CaptchaImage::get_Height()
    .set instance void MSCaptcha.CaptchaImage::set_Height(int32)
  } // end of property CaptchaImage::Height
  .property instance string FontWhitelist()
  {
    .get instance string MSCaptcha.CaptchaImage::get_FontWhitelist()
    .set instance void MSCaptcha.CaptchaImage::set_FontWhitelist(string)
  } // end of property CaptchaImage::FontWhitelist
  .property instance valuetype [System.Drawing]System.Drawing.Color
          BackColor()
  {
    .get instance valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::get_BackColor()
    .set instance void MSCaptcha.CaptchaImage::set_BackColor(valuetype [System.Drawing]System.Drawing.Color)
  } // end of property CaptchaImage::BackColor
  .property instance valuetype [System.Drawing]System.Drawing.Color
          FontColor()
  {
    .set instance void MSCaptcha.CaptchaImage::set_FontColor(valuetype [System.Drawing]System.Drawing.Color)
    .get instance valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::get_FontColor()
  } // end of property CaptchaImage::FontColor
  .property instance valuetype [System.Drawing]System.Drawing.Color
          NoiseColor()
  {
    .set instance void MSCaptcha.CaptchaImage::set_NoiseColor(valuetype [System.Drawing]System.Drawing.Color)
    .get instance valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::get_NoiseColor()
  } // end of property CaptchaImage::NoiseColor
  .property instance valuetype [System.Drawing]System.Drawing.Color
          LineColor()
  {
    .get instance valuetype [System.Drawing]System.Drawing.Color MSCaptcha.CaptchaImage::get_LineColor()
    .set instance void MSCaptcha.CaptchaImage::set_LineColor(valuetype [System.Drawing]System.Drawing.Color)
  } // end of property CaptchaImage::LineColor
} // end of class MSCaptcha.CaptchaImage


// =============================================================

// *********** DISASSEMBLY COMPLETE ***********************
// WARNING: Created Win32 resource file D:\Projects\MOIT\SOS\DLL\MSCaptcha.res
