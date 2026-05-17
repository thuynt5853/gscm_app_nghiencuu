using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace BL.GSTP
{
    public class DM_HDSD
    {
        public decimal ID { get; set; }
        public String FILE_NAME { get; set; }
        public String FILE_URL { get; set; }       
        public String FILE_TYPE { get; set; }
        public String NGUOI_SUA { get; set; }
        public DateTime? DATE_CREATED { get; set; }
        public Int16? STATE { get; set; }
        public decimal? QT_FILE_ID { get; set; }
    }
}