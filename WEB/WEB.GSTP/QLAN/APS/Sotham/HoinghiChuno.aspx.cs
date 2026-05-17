using BL.GSTP;
using BL.GSTP.APS;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.APS.Sotham
{
    public partial class HoinghiChuno : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {

                    string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/APS/Hoso/Danhsach.aspx");
                    loadedit();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(btnKetqua, oPer.CAPNHAT);
                    decimal ID = Convert.ToDecimal(current_id);
                    APS_DON oT = dt.APS_DON.Where(x => x.ID == ID).FirstOrDefault();
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(btnKetqua, false);
                        return;
                    }
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new APS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(btnKetqua, false);
                        return;
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        public void loadedit()
        {
            string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
            decimal DONID = Convert.ToDecimal(current_id);
            List<APS_SOTHAM_HN_CHUNO> lst = dt.APS_SOTHAM_HN_CHUNO.Where(x => x.DONID == DONID).ToList();
            if (lst.Count > 0)
            {
                APS_SOTHAM_HN_CHUNO oND = lst[0];
                hddid.Value = oND.ID.ToString();
                txtSoQD.Text = oND.SOQD;
                if (oND.NGAYQD != null) txtNgayQD.Text = ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);

                txtNQHNCNSo.Text = oND.HNCN_SONQ;
                if (oND.HNCN_NGAY != null) txtNgayNQ.Text = ((DateTime)oND.HNCN_NGAY).ToString("dd/MM/yyyy", cul);

                if (oND.PAPHKD_TUNGAY != null) txtPA_Tungay.Text = ((DateTime)oND.PAPHKD_TUNGAY).ToString("dd/MM/yyyy", cul);
                if (oND.PAPHKD_DENNGAY != null) txtPA_Denngay.Text = ((DateTime)oND.PAPHKD_DENNGAY).ToString("dd/MM/yyyy", cul);
                if (oND.KQ_THUCHIENXONG == 1)
                    rdbKetqua.SelectedValue = "0";
                if (oND.KQ_KHONGTHUCHIEN == 1)
                    rdbKetqua.SelectedValue = "1";
                if (oND.KQ_HETTHOIHAN == 1)
                    rdbKetqua.SelectedValue = "2";
            }
        }

        private bool CheckValid()
        {

            int lengthSoQD = txtSoQD.Text.Trim().Length;
            if (lengthSoQD == 0)
            {
                lbthongbao.Text = "Bạn chưa nhập số quyết định!";
                txtSoQD.Focus();
                return false;
            }
            if (lengthSoQD > 50)
            {
                lbthongbao.Text = "Số quyết định không quá 50 ký tự!";
                txtSoQD.Focus();
                return false;
            }
            if (Cls_Comon.IsValidDate(txtPA_Tungay.Text) == false)
            {
                lbthongbao.Text = "Bạn chưa nhập từ ngày hoặc không hợp lệ !";
                txtPA_Tungay.Focus();
                return false;
            }

            if (Cls_Comon.IsValidDate(txtPA_Denngay.Text) == false)
            {
                lbthongbao.Text = "Bạn chưa nhập đến ngày hoặc không hợp lệ !";
                txtPA_Denngay.Focus();
                return false;
            }
            DateTime tuNgay = DateTime.Parse(txtPA_Tungay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime denNgay = DateTime.Parse(txtPA_Denngay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            if (DateTime.Compare(tuNgay, denNgay) > 0)
            {
                lbthongbao.Text = "Từ ngày phải nhỏ hơn đến ngày !";
                txtPA_Denngay.Focus();
                return false;
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_PHASAN] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                APS_SOTHAM_HN_CHUNO oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new APS_SOTHAM_HN_CHUNO();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.APS_SOTHAM_HN_CHUNO.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.SOQD = txtSoQD.Text;
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.HNCN_SONQ = txtNQHNCNSo.Text;
                oND.HNCN_NGAY = (String.IsNullOrEmpty(txtNgayNQ.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNQ.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.PAPHKD_TUNGAY = (String.IsNullOrEmpty(txtPA_Tungay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtPA_Tungay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.PAPHKD_DENNGAY = (String.IsNullOrEmpty(txtPA_Denngay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtPA_Denngay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.APS_SOTHAM_HN_CHUNO.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                hddid.Value = oND.ID.ToString();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }
        protected void btnKetqua_Click(object sender, EventArgs e)
        {
            try
            {
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    lblthongbao2.Text = "Bạn chưa lưu thông tin quyết định công nhận !";
                    return;
                }

                decimal ID = Convert.ToDecimal(hddid.Value);
                APS_SOTHAM_HN_CHUNO oND = dt.APS_SOTHAM_HN_CHUNO.Where(x => x.ID == ID).FirstOrDefault();
                if (rdbKetqua.SelectedValue == "0")
                {
                    oND.KQ_THUCHIENXONG = 1;
                    oND.KQ_KHONGTHUCHIEN = 0;
                    oND.KQ_HETTHOIHAN = 0;
                }
                else if (rdbKetqua.SelectedValue == "1")
                {
                    oND.KQ_THUCHIENXONG = 0;
                    oND.KQ_KHONGTHUCHIEN = 1;
                    oND.KQ_HETTHOIHAN = 0;
                }
                else if (rdbKetqua.SelectedValue == "2")
                {
                    oND.KQ_THUCHIENXONG = 0;
                    oND.KQ_KHONGTHUCHIEN = 0;
                    oND.KQ_HETTHOIHAN = 1;
                }
                dt.SaveChanges();
                lblthongbao2.Text = "Lưu thành công!";
            }
            catch (Exception ex)
            {
                lblthongbao2.Text = "Lỗi: " + ex.Message;
            }
        }
    }
}