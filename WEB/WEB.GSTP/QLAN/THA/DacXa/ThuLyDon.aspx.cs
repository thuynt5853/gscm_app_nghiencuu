using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.THA;
using Module.Common;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace WEB.GSTP.QLAN.THA.DacXa
{
    public partial class ThuLyDon : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        Decimal VuAnID = 0, BiAnID = 0;
        Decimal ToaAnID = 0;
        THA_DACXA obj = new THA_DACXA();
        Decimal CurrUserID = 0;
        public string NgaySoSanh;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                    if (BiAnID > 0)
                    {
                        pn.Visible = true;
                        ToaAnID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                        txtTentoa.Text = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                        Load_BiAn();

                        loadinfor();
                        CheckQuyen();
                    }
                    else
                    {
                        pn.Visible = false;
                        lbthongbao_top.Text = "Bạn cần chọn bị án để xử lý!";
                    }
                }
            }
            else Response.Redirect("/login.aspx");
        }

        void CheckQuyen()
        {
            Boolean IsOk = true;
            try
            {
                THA_THULY obj = dt.THA_THULY.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_THULY>();
                if (obj != null)
                {
                    NgaySoSanh = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                    IsOk = false;
                }
                else
                {
                    lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                    cmdUpdateVuAn.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                cmdUpdateVuAn.Visible = false;
                IsOk = false;
            }
            //-----------------------------
            if (!IsOk)
            {
                try
                {
                    THA_BIAN_QUYETDINH objQD = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                    if (objQD != null)
                        NgaySoSanh = ((DateTime)objQD.NGAYTHIHANH).ToString("dd/MM/yyyy", cul);
                    else
                    {
                        lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                        cmdUpdateVuAn.Visible = false;
                        IsOk = false;
                    }
                }
                catch (Exception ex)
                {
                    lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                    cmdUpdateVuAn.Visible = false;
                    IsOk = false;
                }
            }
        }
        private void loadinfor()
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_DACXA TM = dt.THA_DACXA.Where(x => x.BIANID == BiAnID).FirstOrDefault();
            if (TM != null)
            {
                txtSothuly.Text = TM.SOTHULY;
                txtNhanxetXa_Phuong.Text = TM.GHICHU;
                rdYeucau_XoaAnTich.SelectedValue = TM.LOAIXOAANTICH + "";
                if (TM.NGAYTHULY != DateTime.MinValue) txtNgay_thuly.Text = ((DateTime)TM.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                //if (TM.NGAYTAODON != DateTime.MinValue) txtNgay_lamdon.Text = ((DateTime)TM.NGAYTAODON).ToString("dd/MM/yyyy", cul);               
                if (TM.NGAYTAODON.HasValue)
                    txtNgay_lamdon.Text = TM.NGAYTAODON.Value.ToString("dd/MM/yyyy", cul);
            }
            // Kiểm tra TOA_GIAIQUYET_ID
            string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
            if (!string.IsNullOrEmpty(donviID) && TM != null && TM.TOA_GIAIQUYET_ID.HasValue)
            {
                if (TM.TOA_GIAIQUYET_ID.ToString() != donviID)
                {
                    DM_TOAAN toaAn = new DM_TOAAN();
                    decimal toaangoc = Convert.ToDecimal(TM.TOA_GIAIQUYET_ID.ToString());                
                    toaAn = dt.DM_TOAAN.Where(x => x.ID == toaangoc ).FirstOrDefault();
                    txtTentoa.Text = toaAn.TEN;
                    cmdUpdateVuAn.Visible = false;
                    lbthongbao.Text = "Đơn đã chuyển sang tòa khác, không thể chỉnh sửa.";
                }
            }
        }
        void Load_BiAn()
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_BIAN obj = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
            if (obj != null)
            {
                VuAnID = (decimal)obj.VUANID;
                hddcurID.Value = VuAnID.ToString();
                txtToidanh.Text = obj.TOIDANH;

            }
        }

        private void Save_Infor(THA_DACXA obj)
        {

            ToaAnID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            //load date

            THA_BIAN objBA = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
            if (objBA != null)
            {
                VuAnID = (decimal)objBA.VUANID;
                hddcurID.Value = VuAnID.ToString();
            }
            try
            {
                obj.NGAYTAODON = (String.IsNullOrEmpty(txtNgay_lamdon.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgay_lamdon.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.NGAYTHULY = (String.IsNullOrEmpty(txtNgay_thuly.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgay_thuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
            //lấy ID theo bang
            obj.VUANID = Convert.ToDecimal(hddcurID.Value);
            obj.BIANID = BiAnID;
            obj.TOAANID = ToaAnID;

            //lấy thông tin theo bảng
            obj.SOTHULY = txtSothuly.Text.Trim();
            obj.LOAIXOAANTICH = Convert.ToDecimal(rdYeucau_XoaAnTich.SelectedValue);
            obj.GHICHU = txtNhanxetXa_Phuong.Text;
        }


        protected void cmdUpdateVuAn_Click(object sender, EventArgs e)
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_DACXA obj = dt.THA_DACXA.Where(x => x.BIANID == BiAnID).FirstOrDefault();
            if (obj != null)
            {
                Save_Infor(obj);
                dt.SaveChanges();
                lbthongbao.Text = "Cập nhật thành công!";
            }
            else
            {
                obj = new THA_DACXA();
                Save_Infor(obj);
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_DACXA.Add(obj);
                dt.SaveChanges();
                lbthongbao.Text = "Lưu thành công!";
            }

        }

    }
}