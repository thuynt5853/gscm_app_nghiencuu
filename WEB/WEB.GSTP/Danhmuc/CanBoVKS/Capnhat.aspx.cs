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

using System.Globalization;

namespace WEB.GSTP.Danhmuc.CanBoVKS
{
    public partial class Capnhat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        private const int ROOT = 0;
        private string PUBLIC_DEPT = "...";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack) {

                    decimal ID_TOAAN = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                    DM_VKS dmvks = dt.DM_VKS.Where(x => x.TOAANID == ID_TOAAN).FirstOrDefault<DM_VKS>();
                    lbTendonvi_VKS.Text = dmvks.TEN;

                    LoadDropChucVu();
                    if (Request["cb"] != null)
                    {
                        decimal cbID = Convert.ToDecimal(Request["cb"].ToString());
                        hddCbID.Value = cbID.ToString();
                        LoadCanBoInfo(cbID);
                    }
                    else DropChucVu.SelectedValue = ENUM_CHUCDANH.CHUCDANH_KSV;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadCanBoInfo(decimal cbID)
        {
            DM_CANBOVKS dmCanBo = dt.DM_CANBOVKS.Where(x => x.ID == cbID).FirstOrDefault<DM_CANBOVKS>();
            if (dmCanBo != null)
            {
                hddCbID.Value = cbID.ToString();

                try { DropChucVu.SelectedValue = dt.DM_DATAITEM.Where(x => x.ID == dmCanBo.CHUCVUID).Single().MA;
                //    if (DropChucVu.SelectedValue == ENUM_CHUCDANH.CHUCDANH_KSV)
                //        cmdUpdate.Visible = false;
                } catch(Exception ex) { }

                txtHoten.Text = dmCanBo.HOTEN;
                txtDiaChi.Text = dmCanBo.DIACHI;
                txtCMND.Text = dmCanBo.SOCMND;
                if (dmCanBo.GIOITINH + "" != "")
                {
                    ddlGioiTinh.SelectedValue = dmCanBo.GIOITINH.ToString();
                }
                txtNgaySinh.Text = string.IsNullOrEmpty(dmCanBo.NGAYSINH + "") ? "" : Convert.ToDateTime(dmCanBo.NGAYSINH).ToString("dd/MM/yyyy");
                txtDienThoai.Text = dmCanBo.SODIENTHOAI;

                txtNgayNhanCT.Text = string.IsNullOrEmpty(dmCanBo.NGAYNHANCONGTAC + "") ? "" : Convert.ToDateTime(dmCanBo.NGAYNHANCONGTAC).ToString("dd/MM/yyyy");
                chkHieuluc.Checked = string.IsNullOrEmpty(dmCanBo.HIEULUC + "") ? false : Convert.ToBoolean(dmCanBo.HIEULUC);
            }
        }
        public void LoadDropChucVu()
        {
            DropChucVu.Items.Clear();
            //DropChucVu.Items.Add(new ListItem("Chọn", ""));
            DropChucVu.Items.Add(new ListItem("Hội thẩm nhân dân", ENUM_CHUCDANH.CHUCDANH_HTND));
            DropChucVu.Items.Add(new ListItem("Kiểm sát viên", ENUM_CHUCDANH.CHUCDANH_KSV));
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            decimal cbID = Convert.ToDecimal(hddCbID.Value);
            if (!ValidateData())
                return;

            //------------------------
            bool isNew = false;
            DM_CANBOVKS dmCanBo = dt.DM_CANBOVKS.Where(x => x.ID == cbID).FirstOrDefault<DM_CANBOVKS>();
            if (dmCanBo == null)
            {
                isNew = true;
                dmCanBo = new DM_CANBOVKS();
                dmCanBo.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                dmCanBo.NGAYTAO = DateTime.Now;
            }
            else
            {
                dmCanBo.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                dmCanBo.NGAYSUA = DateTime.Now;
            }

            decimal ID_TOAAN = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");

            DM_VKS dmvks = dt.DM_VKS.Where(x => x.TOAANID == ID_TOAAN).FirstOrDefault<DM_VKS>();
            dmCanBo.VSKID = dmvks.ID;
            //------------------------
            dmCanBo.CHUCVUID = 0;
            string ma_chuc_vu = DropChucVu.SelectedValue;
            DM_DATAITEM objCV = dt.DM_DATAITEM.Where(x => x.MA == ma_chuc_vu ).FirstOrDefault();
            if (objCV != null)
                dmCanBo.CHUCVUID = Convert.ToDecimal(objCV.ID);

            //------------------------
            dmCanBo.HOTEN = txtHoten.Text.Trim();
            dmCanBo.DIACHI = txtDiaChi.Text.Trim();
            dmCanBo.SOCMND = txtCMND.Text.Trim();
            dmCanBo.GIOITINH = Convert.ToDecimal(ddlGioiTinh.SelectedValue);
            if (txtNgaySinh.Text.Trim() != "")
            {
                CultureInfo cul = new CultureInfo("vi-VN");
                dmCanBo.NGAYSINH =  DateTime.Parse(this.txtNgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            dmCanBo.SODIENTHOAI = txtDienThoai.Text.Trim();
            if (txtNgayNhanCT.Text.Trim() != "")
                dmCanBo.NGAYNHANCONGTAC = Convert.ToDateTime(txtNgayNhanCT.Text.Trim());
            dmCanBo.HIEULUC = chkHieuluc.Checked ? 1 : 0;

            if (isNew)
                dt.DM_CANBOVKS.Add(dmCanBo);
            dt.SaveChanges();
            Response.Redirect("Danhsach.aspx");
        }
        private bool ValidateData()
        {
            int lengthTenCB = txtHoten.Text.Trim().Length;
            if (lengthTenCB == 0 || lengthTenCB > 250)
            {
                lbthongbao.Text = "Tên cán bộ không được trống hoặc quá 250 ký tự. Hãy nhập lại!";
                txtHoten.Focus();
                return false;
            }
            if (txtDiaChi.Text.Trim().Length > 250)
            {
                lbthongbao.Text = "Địa chỉ không được quá 250 ký tự. Hãy nhập lại!";
                txtDiaChi.Focus();
                return false;
            }
            if (txtCMND.Text.Trim().Length > 50)
            {
                lbthongbao.Text = "Số CMND không được quá 50 ký tự. Hãy nhập lại!";
                txtCMND.Focus();
                return false;
            }
            if (txtNgaySinh.Text.Trim() != "" && !Cls_Comon.IsValidDate(txtNgaySinh.Text.Trim()))
            {
                lbthongbao.Text = "Ngày sinh phải là kiểu ngày tháng (dd/MM/yyyy). Hãy nhập lại!";
                txtNgaySinh.Focus();
                return false;
            }
            if (txtDienThoai.Text.Trim().Length > 50)
            {
                lbthongbao.Text = "Số điện thoại không được quá 50 ký tự. Hãy nhập lại!";
                txtDienThoai.Focus();
                return false;
            }
            if (txtNgayNhanCT.Text.Trim() != "" && !Cls_Comon.IsValidDate(txtNgayNhanCT.Text.Trim()))
            {
                lbthongbao.Text = "Ngày nhận công tác phải là kiểu ngày tháng (dd/MM/yyyy). Hãy nhập lại!";
                txtNgayNhanCT.Focus();
                return false;
            }
            return true;
        }
        protected void lblquaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }
    }
}