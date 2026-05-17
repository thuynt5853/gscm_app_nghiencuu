using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.DLQGC06;
using Newtonsoft.Json;

namespace WEB.GSTP.QLAN.C06
{
    public partial class pToiDanh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        public Decimal BiCanID = 0, BanAnID = 0, VuAnID = 0, Id = 0;
        string capxx = "SO_THAM";
        public decimal NhomHinhPhatBS = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
            {
                VuAnID = (String.IsNullOrEmpty(Request["aID"] + "")) ? 0 : Convert.ToDecimal(Request["aID"] + "");
                //VuAnID = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                NhomHinhPhatBS = dt.DM_DATAITEM.Where(x => x.MA == ENUM_NHOMHINHPHAT.NHOM_HPBOSUNG).SingleOrDefault().ID;
                capxx = Request["capxx"] + "";
                if (!IsPostBack)
                {
                    
                    BiCanID = (String.IsNullOrEmpty(Request["bID"] + "")) ? 0 : Convert.ToDecimal(Request["bID"] + "");
                    Id = (String.IsNullOrEmpty(Request["ID"] + "")) ? 0 : Convert.ToDecimal(Request["ID"] + "");
                    string tenBiCan = dt.AHS_BICANBICAO.FirstOrDefault(x => x.ID == BiCanID).HOTEN;
                    lblTenBiCao.Text = tenBiCan;
                    hddBanAnID.Value = BanAnID.ToString();
                    LoadData();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        private void LoadData()
        {
            DLQGC06_AHS_BL obl = new DLQGC06_AHS_BL();
            DataTable tbl = obl.c06_ahs_dieuct_getall(BiCanID, VuAnID, capxx);
            // Lấy danh sách hình phạt
            DataTable ahsDongBoTbl = obl.c06_toaan_hinhsu_getbyid(Id);
            List<HinhPhatDisplayModel> hinhPhats = new List<HinhPhatDisplayModel>();
            //Lấy hình phạt chính
            //HinhPhatDisplayModel hpc = new HinhPhatDisplayModel()
            //{
            //    maHinhPhat = ahsDongBoTbl.Rows[0]["MAHINHPHATCHINH"].ToString(),
            //    tenHinhPhat = ahsDongBoTbl.Rows[0]["TENHINHPHATCHINH"].ToString(),
            //    thamSoHinhPhat = ahsDongBoTbl.Rows[0]["THAMSOHINHPHATCHINH"].ToString(),
            //    loaiHinhPhat = "Hình phạt chính"
            //};
            //hinhPhats.Add(hpc);
            // Lấy hình phạt bổ sung
            string jsonToiDanh = ahsDongBoTbl.Rows[0]["DSTOIDANH"].ToString();
            if (!string.IsNullOrEmpty(jsonToiDanh))
            {
                List<ToiDanhModel> toiDanhs = JsonConvert.DeserializeObject<List<ToiDanhModel>>(jsonToiDanh);
                foreach (var toiDanhItem in toiDanhs)
                {
                    if(toiDanhItem.dSachHinhPhat != null)
                    {
                        List<HinhPhatModel> hinhPhatList = toiDanhItem.dSachHinhPhat;
                        foreach (HinhPhatModel item in hinhPhatList)
                        {
                            HinhPhatDisplayModel hp = new HinhPhatDisplayModel()
                            {
                                maHinhPhat = item.maHinhPhat,
                                tenHinhPhat = item.tenHinhPhat,
                                thamSoHinhPhat = item.thamSoHinhPhat,
                                loaiHinhPhat = item.hinhPhatChinh == 1 ? "Hình phạt chính" : "Hình phạt bổ sung"
                            };
                            hinhPhats.Add(hp);
                        }
                    }
                }
            }
            rpt.DataSource = tbl;
            rpt.DataBind();
            gvHinhPhat.DataSource = hinhPhats;
            gvHinhPhat.DataBind();
        }
        
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
               
            }
        }

        protected void rpt_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {

        }



    }
}