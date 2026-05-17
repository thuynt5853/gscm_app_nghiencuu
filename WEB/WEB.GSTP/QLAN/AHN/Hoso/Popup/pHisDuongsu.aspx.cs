using BL.GSTP;
using BL.GSTP.AHN;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Serialization;
using System.IO;

namespace WEB.GSTP.QLAN.AHN.Hoso.Popup
{
    public partial class pHisDuongsu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal DonID = 0, DuongSuID = 0;
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                AHN_DON_DUONGSU_BL oDonBL = new AHN_DON_DUONGSU_BL();
                DuongSuID = (String.IsNullOrEmpty(Request["vDsID"] + "")) ? 0 : Convert.ToDecimal(Request["vDsID"] + "");


                List<AHN_DON_DUONGSU_HIS> xmlList = oDonBL.GetHistoryDuongSu(DuongSuID);  // Lấy list string
                
                var result = xmlList.Select(d =>
                {
                    // Parse XML thành đối tượng gốc
                    var obj = FromXmlString<AHN_DON_DUONGSU>(d.DUONGSU_XML);

                    return new AHN_DON_DUONGSU_DTO
                    {
                        // Metadata
                        HIS_TAIKHOANSUA = d.HIS_TAIKHOANSUA,
                        HIS_NGUOISUA = d.HIS_NGUOISUA,
                        HIS_NGAYSUA = d.HIS_NGAYSUA,

                        // Thuộc tính lấy từ XML
                        ID = obj.ID,
                        TENDUONGSU = obj.TENDUONGSU,
                        LOAIDUONGSU = obj.LOAIDUONGSU,
                        TENLOAIDS = obj.LOAIDUONGSU == 1 ? "Cá nhân" :
                                    obj.LOAIDUONGSU == 2 ? "Cơ quan" :
                                    obj.LOAIDUONGSU == 3 ? "Tổ chức" : "",
                        DAIDIEN = obj.ISDAIDIEN == 1 ? "X" : "",
                        TAMTRUID = obj.TAMTRUID,
                        NDD_DIACHIID = obj.NDD_DIACHIID,
                        QUOCTICH = obj.QUOCTICHID,
                        TUCACHTOTUNG_MA = obj.TUCACHTOTUNG_MA,
                        NAMSINH = obj.NAMSINH,
                        ISSOTHAM = obj.ISSOTHAM,
                        TRANGTHAIXACTHUC = obj.XACTHUC_DLDCQG,
                        NGUOITAO = obj.NGUOITAO,
                        NGAYTAO = obj.NGAYTAO
                    };
                }).ToList();
                dgList.DataSource = result;
                dgList.DataBind();

            }
        }
        // 2. Hàm generic đọc XML -> object
        public static T FromXmlString<T>(string xml)
        {
            var ser = new XmlSerializer(typeof(T));
            var sr = new StringReader(xml);
            return (T)ser.Deserialize(sr);
        }

        public class AHN_DON_DUONGSU_DTO
        {
            public string HIS_NGUOISUA { get; set; }
            public string HIS_TAIKHOANSUA { get; set; }
            public DateTime? HIS_NGAYSUA { get; set; }

            public decimal ID { get; set; }
            public string TENDUONGSU { get; set; }
            public decimal? LOAIDUONGSU { get; set; }
            public string TENLOAIDS { get; set; }
            public string TUCACHTOTUNG_MA { get; set; }
            
            public decimal? NAMSINH { get; set; }
            public decimal? QUOCTICH { get; set; }
            public string DAIDIEN { get; set; }
            public decimal? TAMTRUID { get; set; }
            public decimal? NDD_DIACHIID { get; set; }
            public string TENTCTT { get; set; }
            public decimal? ISSOTHAM { get; set; }
            public decimal? TRANGTHAIXACTHUC { get; set; }
            
            public string NGUOITAO { get; set; }
            public DateTime? NGAYTAO { get; set; }
            public string ARRDUONGSU { get; set; }
        }
       

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
           
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                //DataRowView rv = (DataRowView)e.Item.DataItem;
                var dto = (AHN_DON_DUONGSU_DTO)e.Item.DataItem;

                Literal lttDiaChi = (Literal)e.Item.FindControl("lttDiaChi");
                Literal lttTuCachToTung = (Literal)e.Item.FindControl("lttTuCachToTung");
                

                int vLOAIDUONGSU = String.IsNullOrEmpty(dto.LOAIDUONGSU.ToString()) ? 0 : Convert.ToInt16(dto.LOAIDUONGSU);
                if (vLOAIDUONGSU == 1)
                {
                    int TAMTRUID = String.IsNullOrEmpty(dto.TAMTRUID.ToString()) ? 0 : Convert.ToInt16(dto.TAMTRUID);
                    DM_HANHCHINH h1 = dt.DM_HANHCHINH.Where(x => x.ID == TAMTRUID).First();
                    if (h1 != null)
                        lttDiaChi.Text = h1.MA_TEN;
                }
                else
                {
                    int NDD_DIACHIID = String.IsNullOrEmpty(dto.NDD_DIACHIID.ToString()) ? 0 : Convert.ToInt16(dto.NDD_DIACHIID);
                    DM_HANHCHINH h2 = dt.DM_HANHCHINH.Where(x => x.ID == NDD_DIACHIID).First();
                    if (h2 != null)
                        lttDiaChi.Text = h2.MA_TEN;
                }

                string vTUCACHTOTUNG_MA = dto.TUCACHTOTUNG_MA;
                if (vTUCACHTOTUNG_MA !="")
                {
                    DM_DATAITEM tucach = dt.DM_DATAITEM.Where(x => x.MA == vTUCACHTOTUNG_MA).First();
                    if (tucach != null)
                        lttTuCachToTung.Text = tucach.TEN;
                }
                


            }
        }

    }
}