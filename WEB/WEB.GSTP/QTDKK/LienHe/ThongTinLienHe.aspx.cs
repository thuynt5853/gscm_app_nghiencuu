using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QTDKK.LienHe
{
    public partial class ThongTinLienHe : System.Web.UI.Page
    {
        private string PUBLIC_DEPT = "..";
        GSTPContext dt = new GSTPContext();
        private const int ROOT = 0, DEL = 0, ADD = 1, UPDATE = 2;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                loadedit();
        }
        public void loadedit()
        {
            decimal toaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == toaAnID).FirstOrDefault();
            if (toaAn != null)
            {
                txtMa.Text = toaAn.MA;
                txtTen.Text = toaAn.TEN;
                decimal tempid = (string.IsNullOrEmpty(toaAn.CAPCHAID+""))?0:(decimal)toaAn.CAPCHAID;
                if (tempid>0)
                    txtToaAnCapTren.Text =  dt.DM_TOAAN.Where(x=>x.ID == tempid).SingleOrDefault().TEN;
                //---------------------
                string temp = toaAn.LOAITOA;
                DM_DATAGROUP group = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.LOAITOA).SingleOrDefault();
                tempid = group.ID;
                txtLoaiToaAn.Text = dt.DM_DATAITEM.Where(x=>x.MA == temp&& x.GROUPID == tempid).SingleOrDefault().TEN;
                
                //--------------------------
                if (toaAn.HANHCHINHID != 0)
                {
                    DM_HANHCHINH_BL hcbl = new DM_HANHCHINH_BL();
                    txtDonViHanhChinh.Text = hcbl.GetTextByID(Convert.ToDecimal(toaAn.HANHCHINHID));
                    hddDonViHanhChinh.Value = toaAn.HANHCHINHID.ToString();
                }
                else
                {
                    txtDonViHanhChinh.Text = "";
                    hddDonViHanhChinh.Value = "0";
                }
                txtDiaChi.Text = toaAn.DIACHI;
                txtDienThoai.Text = toaAn.DIENTHOAI;
                txtFax.Text = toaAn.FAX;
                txtEmail.Text = toaAn.EMAIL;
                
                int status = String.IsNullOrEmpty(toaAn.NHANDKKONLINE + "") ? 0 : (int)toaAn.NHANDKKONLINE;
                lttNhanDonOnline.Text =(status==0)? "Không nhận đơn khởi kiện trực tuyến" :"Nhận đơn khởi kiện trực tuyến";

            }
            else
            {
                txtTen.Text = txtMa.Text = "";
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                decimal toaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
               
                string Ten = txtTen.Text.Trim(), nodeName = "";
                bool isNew = false;
                DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == toaAnID).FirstOrDefault<DM_TOAAN>();
                //if (toaAn == null)
                //{
                //    isNew = true;
                //    toaAn = new DM_TOAAN();
                //    toaAn.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                //    toaAn.NGAYTAO = DateTime.Now;
                //}
                //else
                if (toaAn != null)
                {
                    toaAn.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    toaAn.NGAYSUA = DateTime.Now;
                    nodeName = toaAn.TEN;
                }
                toaAn.MA = txtMa.Text.Trim();
                toaAn.TEN = Ten;
                toaAn.DIACHI = txtDiaChi.Text.Trim();
                toaAn.DIENTHOAI = txtDienThoai.Text.Trim();
                toaAn.FAX = txtFax.Text.Trim();
                toaAn.EMAIL = txtEmail.Text.Trim();                
                dt.SaveChanges();
               
                toaAnID = toaAn.ID;              
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

    }
}