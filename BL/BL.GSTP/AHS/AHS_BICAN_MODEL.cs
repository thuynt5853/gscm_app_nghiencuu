
using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BL.GSTP.AHS
{
    public class AHS_BICAN_MODEL
    {
        public AHS_BICANBICAO AHS_BICANBICAO { get; set; }
        public AHS_BICAN_MODEL()
        {
            AHS_BICANBICAO = new AHS_BICANBICAO();
        }
    }
    public class AHS_BICAN_HISTORY_MODEL
    {
        public string HIS_NGUOISUA { get; set; }
        public string HIS_TAIKHOANSUA { get; set; }
        public string HIS_NGAYSUA { get; set; }
        public string TEN_BICAN { get; set; }
        public string DIACHI { get; set; }
        public string TOIDANH { get; set; }
        public string TRANGTHAIXACTHUC { get; set; }
        public string NGUOITAO { get; set; }
        public string NGAYTAO { get; set; }
    }
}