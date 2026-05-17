
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;

using System.Globalization;
using System.Web.UI.WebControls;

using DAL.DKK;
using BL.GSTP.Danhmuc;

using BL.DonKK.DanhMuc;

namespace WEB.GSTP.QTDKK.Tinbai
{
    public partial class CapnhatTB : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const int ROOT = 0, DEL = 0, ADD = 1, UPDATE = 2;
        private string PUBLIC_DEPT = "...";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDropChuyenMuc();
                    if (!string.IsNullOrEmpty(Request["tbID"]))
                    {
                        int CurrID = 0;
                        CurrID = Convert.ToInt32(Request["tbID"] + "");
                        LoadInfo(CurrID);
                    }
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadDropChuyenMuc()
        {
            dropChuyenMuc.Items.Clear();
            dropChuyenMuc.DataSource = null;
            dropChuyenMuc.DataBind();
            dropChuyenMuc.Items.Add(new ListItem("---Chọn---", ROOT.ToString()));
            LoadDropChuyenMucListChild(0, PUBLIC_DEPT);
        }
        private void LoadDropChuyenMucListChild(decimal pID, string dept)
        {
            DataTable tbl = null;
            DONKK_CHUYENMUC_BL obj = new DONKK_CHUYENMUC_BL();
            tbl = obj.GetAllByCapChaID(pID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Decimal current_id = 0;
                foreach (DataRow row in tbl.Rows)
                {
                    current_id = Convert.ToDecimal(row["ID"].ToString());
                    dropChuyenMuc.Items.Add(new ListItem(dept + row["TENCHUYENMUC"] + "", current_id.ToString()));
                    LoadDropChuyenMucListChild(current_id, PUBLIC_DEPT + dept);
                }
            }
        }
        protected void btnLuuTam_Click(object sender, EventArgs e)
        {
            SaveData(1);
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            SaveData(0);
        }
        protected void btnXuatBan_Click(object sender, EventArgs e)
        {
            SaveData(2);
        }
        protected void btnHuyXuatBan_Click(object sender, EventArgs e)
        {
            SaveData(3);
        }
        void SaveData(int trangthai)
        {
            DONKK_TINTUC obj = new DONKK_TINTUC();
            int CurrID = 0;
            DataRow row = null;
            //--check--------------------------------
            int chuyenmucid = Convert.ToInt32(dropChuyenMuc.SelectedValue);
            string tieude = txtTen.Text.Trim();

            try
            {
                if (!string.IsNullOrEmpty(Request["tbID"]))
                {
                    CurrID = Convert.ToInt32(Request["tbID"] + "");
                    obj = dt.DONKK_TINTUC.Where(x => x.ID == CurrID).Single<DONKK_TINTUC>();
                }
                else
                    obj = new DONKK_TINTUC();
            }
            catch (Exception ex)
            {
                obj = new DONKK_TINTUC();
            }
            obj.PAGECODE = txtPageCode.Text.Trim();
            obj.CHUYENMUCID = chuyenmucid;
            obj.TIEUDE = tieude;
            obj.TRICHDAN = txtTrichDan.Text.Trim();
            obj.NOIDUNG = txtNoiDung.Text.Trim();
            if (!string.IsNullOrEmpty(txtNgayTinBai.Text.Trim()))
                obj.NGAYTINBAI = DateTime.Parse(txtNgayTinBai.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            else
                obj.NGAYTINBAI = DateTime.Now;

            if (CurrID == 0)
            {
                obj.TRANGTHAI = trangthai;
                obj.NGAYTAO = DateTime.Now;
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.DONKK_TINTUC.Add(obj);
            }
            else
            {
                if (trangthai > 0)
                    obj.TRANGTHAI = trangthai;
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            }

            dt.SaveChanges();
            Response.Redirect("DanhsachTB.aspx");
        }
        void AnHienButtom(int trangthai)
        {
            if(trangthai==1)
            {
                cmdUpdate.Visible = true;
                cmdLuuTam.Visible = false;
            }
            if (trangthai == 2)
            {
                cmdUpdate.Visible = true;
                cmdLuuTam.Visible = false;
                cmdXuanBan.Visible = false;
                cmdHuyXuatBan.Visible = true;
            }
            if (trangthai == 3)
            {
                cmdUpdate.Visible = true;
                cmdLuuTam.Visible = false;
                cmdHuyXuatBan.Visible = false;
            }

        }
        protected void btnQuayLai_Click(object sender, EventArgs e)
        {
            Response.Redirect("DanhsachTB.aspx");
        }

        public void LoadInfo(decimal ID)
        {
            DONKK_TINTUC oT = dt.DONKK_TINTUC.Where(x => x.ID == ID).FirstOrDefault();
            if (oT == null) return;
            {
                dropChuyenMuc.SelectedValue = oT.CHUYENMUCID.ToString();
                txtTen.Text = oT.TIEUDE;
                txtTrichDan.Text = oT.TRICHDAN;
                txtNoiDung.Text = oT.NOIDUNG;
                txtNgayTinBai.Text = ((DateTime)oT.NGAYTINBAI).ToString("dd/MM/yyyy", cul);
                txtPageCode.Text = oT.PAGECODE + "";
                AnHienButtom(Convert.ToInt32(oT.TRANGTHAI));
            }
        }
    }
}
