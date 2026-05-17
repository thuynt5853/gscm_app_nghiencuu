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




namespace WEB.GSTP.QLAN.THA.XoaAnTich
{
    public partial class ThuLyDon : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        Decimal VuAnID = 0, BiAnID = 0;
        Decimal ToaAnID = 0;
        THA_ANTICH_DON obj = new THA_ANTICH_DON();
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
            else
                Response.Redirect("/Login.aspx");
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
            THA_ANTICH_DON TM = dt.THA_ANTICH_DON.Where(x => x.BIANID == BiAnID).FirstOrDefault();
            if (TM != null)
            {
                txtSothuly.Text = TM.SOTHULY;
                txtNhanxetXa_Phuong.Text = TM.GHICHU;
                if (TM.NGAYTHULY != DateTime.MinValue && TM.NGAYTHULY != null) txtNgay_thuly.Text = ((DateTime)TM.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                if (TM.NGAYTAODON != DateTime.MinValue && TM.NGAYTAODON != null) txtNgay_lamdon.Text = ((DateTime)TM.NGAYTAODON).ToString("dd/MM/yyyy", cul);
                // VNPT - Lưu Quang Huy - thêm trường người đề nghị - 17-09-2025 13:55
                txtNguoiDeNghi.Text = TM.NGUOIDENGHI;
            }
            // Kiểm tra TOA_GIAIQUYET_ID
            string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
            if (!string.IsNullOrEmpty(donviID) && TM != null && TM.TOA_GIAIQUYET_ID.HasValue)
            {
                if (TM.TOA_GIAIQUYET_ID.ToString() != donviID)
                {
                    cmdUpdateVuAn.Visible = false;
                    cmdXoaTLAnTich.Visible = false;
                    lbthongbao.Text = "Đơn đã chuyển sang tòa khác, không thể chỉnh sửa.";
                }
            }
            //rdYeucau_XoaAnTich.SelectedValue = "1";
        }
        void Load_BiAn()
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_BIAN obj = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
            AHS_SOTHAM_CAOTRANG_DIEULUAT oCT_DL = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiAnID).FirstOrDefault(); 
            if (obj != null && oCT_DL != null)
            {
                VuAnID = (decimal)obj.VUANID;
                hddcurID.Value = VuAnID.ToString();
                txtToidanh.Text = oCT_DL.TENTOIDANH;
            }
        }

        void ResetControls()
        {
            txtNgay_lamdon.Text = "";
            txtNguoiDeNghi.Text = "";
            txtSothuly.Text = "";
            txtNhanxetXa_Phuong.Text = "";
        }

        private void Save_Infor(THA_ANTICH_DON obj)
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
            //obj.LOAIXOAANTICH = Convert.ToDecimal(rdYeucau_XoaAnTich.SelectedValue);
            obj.NGUOIDENGHI = txtNguoiDeNghi.Text;
            obj.GHICHU = txtNhanxetXa_Phuong.Text;
        }
       
        protected void cmdUpdateVuAn_Click(object sender, EventArgs e)
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_ANTICH_DON obj = dt.THA_ANTICH_DON.Where(x => x.BIANID == BiAnID).FirstOrDefault();
            if (obj != null)
            {
                Save_Infor(obj);
                dt.SaveChanges();
                lbthongbao.Text = "Cập nhật thành công!";
            }
            else
            {
                obj = new THA_ANTICH_DON();
                Save_Infor(obj);
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_ANTICH_DON.Add(obj);
                dt.SaveChanges();
                lbthongbao.Text = "Lưu thành công!";
            }
        }
        protected void cmdXoaTLAnTich_Click(object sender, EventArgs e)
        {
            try
            {
                Xoa_ThuLy_XoaAnTich();
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Xóa Thụ lý đơn đề nghị xóa án tích thành công!");
            }
            catch (Exception ex) { }
        }
        void Xoa_ThuLy_XoaAnTich()
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            VuAnID = Convert.ToDecimal(hddcurID.Value);
            //Xóa Thu ly xoa an tích
            THA_ANTICH_DON objbs = null;
            try
            {
                objbs = dt.THA_ANTICH_DON.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID).Single<THA_ANTICH_DON>();
            }
            catch (Exception ex) { }

            if (objbs != null)
            {
                dt.THA_ANTICH_DON.Remove(objbs);
                dt.SaveChanges();
                lbthongbao.Text = "Xóa Thụ lý đơn đề nghị xóa án tích thành công!";
                ResetControls();
            }
            
        }

    }
}