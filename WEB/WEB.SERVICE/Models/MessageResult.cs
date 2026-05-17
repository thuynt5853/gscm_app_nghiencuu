using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.Service.Models
{
    public class MessageResult
    {
        public string Status { get; set; }
        public string Message { get; set; }

        public object Data { get; set; }

        public static MessageResult _error(string message)
        {
            MessageResult error = new MessageResult();
            error.Status = "01"; ;
            error.Message = message;
            return error;
        }

        public static MessageResult _success(object data)
        {
            MessageResult success = new MessageResult();
            success.Status = "00";
            success.Message = "Success";
            success.Data = data;
            return success;
        }
    }
}