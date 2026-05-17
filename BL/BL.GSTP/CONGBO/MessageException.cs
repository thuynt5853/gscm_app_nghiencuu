using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class MessageException : Exception
    {
        public MessageException() : base() { }
        public MessageException(string message) : base(message) { }
        public MessageException(string message, Exception innerException) : base(message, innerException) { }
        public override string StackTrace
        {
            get { return "Stacktrace disable"; }
        }
    }
}