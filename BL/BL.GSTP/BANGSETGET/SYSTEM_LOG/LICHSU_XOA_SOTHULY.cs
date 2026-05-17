using System;
using System.Web.UI;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Module.Common;
using System.Web.Script.Serialization;

using Oracle.ManagedDataAccess.Client;

namespace BL.GSTP.BANGSETGET.SYSTEM_LOG
{
    public class LICHSU_XOA_SOTHULY
    {
        public Decimal ID { get; set; }
        public Decimal LOAIAN { get; set; }
        public String MAVUVIEC { get; set; }
        public String TENVUVIEC { get; set; }
        public String TENTOAAN { get; set; }
        public String SOTHULY { get; set; }
        public DateTime? NGAYTHULY { get; set; }

        public Decimal TOAAN_ID { get; set; }
        public String TAIKHOANXOA { get; set; }
        public String NGUOIXOA { get; set; }

        public DateTime? NGAYXOA { get; set; }

        public String NOIDUNG { get; set; }
        public String TENCHUCNANG { get; set; }
        public Decimal HANHDONG { get; set; }
        public String LYDO { get; set; }
        public Decimal MAGIAIDOAN { get; set; }
        public Decimal DONID { get; set; }

        public bool insert_LICHSU_XOA_SOTHULY(decimal in_MAGIAIDOAN, decimal in_THULYID, decimal in_LOAIANID, decimal in_NGUOIXOAID, string in_TAIKHOANXOA, string in_LYDO, decimal in_DONID)
        {
            try
            {
                //2 - Sơ thẩm, 3 - Phúc thẩm
                if (in_MAGIAIDOAN == 2)
                {
                    OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("in_MAGIAIDOAN", in_MAGIAIDOAN),
                    new OracleParameter("in_DONID", in_DONID),
                    new OracleParameter("in_THULYID", in_THULYID),
                    new OracleParameter("in_LOAIANID", in_LOAIANID),
                    new OracleParameter("in_NGUOIXOAID", in_NGUOIXOAID),
                    new OracleParameter("in_TAIKHOANXOA", in_TAIKHOANXOA),
                    new OracleParameter("in_LYDO", in_LYDO)
                    };

                    decimal dbl = Cls_Comon.ExcuteProcResult("PKG_STPT_DELETE_SOTHULY.LICHSU_XOA_SOTHULY_ST", parameters);
                    return dbl == 1 ? true : false;
                }
                else if (in_MAGIAIDOAN == 3)
                {
                    OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("in_MAGIAIDOAN", in_MAGIAIDOAN),
                    new OracleParameter("in_DONID", in_DONID),
                    new OracleParameter("in_THULYID", in_THULYID),
                    new OracleParameter("in_LOAIANID", in_LOAIANID),
                    new OracleParameter("in_NGUOIXOAID", in_NGUOIXOAID),
                    new OracleParameter("in_TAIKHOANXOA", in_TAIKHOANXOA),
                    new OracleParameter("in_LYDO", in_LYDO)
                    };

                    decimal dbl = Cls_Comon.ExcuteProcResult("PKG_STPT_DELETE_SOTHULY.LICHSU_XOA_SOTHULY_PT", parameters);
                    return dbl == 1 ? true : false;
                }
                return false;
            }
            catch (Exception ex) { return false; }

        }
    }
}