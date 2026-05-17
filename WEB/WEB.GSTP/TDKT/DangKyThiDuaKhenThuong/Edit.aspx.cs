using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.TDKT.DangKyThiDuaKhenThuong
{
    public partial class Edit : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                if (!IsPostBack)
                {
                    LoadDropToaAn();
                    hddID.Value = Request["ds"] + "" == "" ? "0" : Request["ds"] + "";
                    decimal ID = 0;
                    if (decimal.TryParse(hddID.Value, out ID))
                    {
                        LoadInfo(ID);
                        hddID.Value = ID.ToString();
                    }
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadDropToaAn()
        {
            decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            string LoaiToa = "";
            DM_TOAAN ObjTA = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
            if (ObjTA != null)
            {
                LoaiToa = ObjTA.LOAITOA;
            }
            if (LoaiToa == "TOICAO")
            {
                DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                DropToaAn.DataSource = oBL.DM_TOAAN_GETBY(DonViLoginID);
                DropToaAn.DataTextField = "arrTEN";
                DropToaAn.DataValueField = "ID";
                DropToaAn.DataBind();

                DropToaAn.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            else
            {
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
                if (oT != null)
                    DropToaAn.Items.Add(new ListItem(oT.MA_TEN, oT.ID.ToString()));
                else
                    DropToaAn.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
        }
        private void LoadInfo(decimal ID)
        {
            Lblthongbao.Text = "";
            TDKT_DANH_SACH Obj = dt.TDKT_DANH_SACH.Where(x => x.ID == ID).FirstOrDefault<TDKT_DANH_SACH>();
            if (Obj != null)
            {
                DropToaAn.SelectedValue = Obj.TOAANID + "";
                TxtTenDanSach.Text = Obj.TEN_DANH_SACH;
                DropLoaiDeNghi.SelectedValue = Obj.LOAI_DE_NGHI + "";
                TxtNam.Text = Obj.NAM + "";
                //TxtSoQD.Text = Obj.SOQD;
                //TxtNgayQD.Text = Obj.NGAYQD + "" == "" ? "" : ((DateTime)Obj.NGAYQD).ToString("dd/MM/yyyy");
                TxtNguoiLap.Text = Obj.NGUOI_LAP;
                TxtNgayLap.Text = Obj.NGAYLAP + "" == "" ? "" : ((DateTime)Obj.NGAYLAP).ToString("dd/MM/yyyy");
                TxtNguoiDuyet.Text = Obj.NGUOI_DUYET_TEN;
                TxtChucVu.Text = Obj.NGUOI_DUYET_CHUC_VU;
                #region Tệp đính kèm
                //LbtDownload.Text = Obj.FILE_TEN;
                //if (Obj.FILE_TEN + "" != "")
                //{
                //    ImgXoa.Visible = true;
                //}
                //else
                //{
                //    ImgXoa.Visible = false;
                //}
                #endregion
            }
        }
        protected void BtnLuu_Click(object sender, EventArgs e)
        {
            try
            {
                SaveData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.InnerException.ToString(); }
        }
        protected void BtnLamMoi_Click(object sender, EventArgs e)
        {
            ResetData();
        }
        protected void BtnQuayLai_Click(object sender, EventArgs e)
        {
            string link = Cls_Comon.GetRootURL() + "/TDKT/DangKyThiDuaKhenThuong/Danhsach.aspx?pag=" + Request["pag"] + "&dv=" + DropToaAn.SelectedValue;
            Response.Redirect(link);
        }
        private void ResetData()
        {
            Lblthongbao.Text = "";
            TxtTenDanSach.Text = "";
            DropLoaiDeNghi.SelectedIndex = 0;
            TxtNam.Text = "";
            //TxtSoQD.Text = "";
            //TxtNgayQD.Text = "";
            TxtNguoiLap.Text = "";
            TxtNgayLap.Text = "";
            TxtNguoiDuyet.Text = "";
            TxtChucVu.Text = "";
            #region Tệp đính kèm
            //LbtDownload.Text = "";
            //ImgXoa.Visible = false;
            #endregion
        }
        private void SaveData()
        {
            if (!CheckData())
            {
                return;
            }
            if (!CheckExist())
            {
                Lblthongbao.Text = "Danh sách này đã tồn tại. Hãy xem lại.";
                return;
            }
            //
            decimal ID = Convert.ToDecimal(hddID.Value);
            TDKT_DANH_SACH Obj = dt.TDKT_DANH_SACH.Where(x => x.ID == ID).FirstOrDefault<TDKT_DANH_SACH>();
            if (Obj == null)
            {
                Obj = new TDKT_DANH_SACH
                {
                    NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString(),
                    NGAYTAO = DateTime.Now
                };
            }
            else
            {
                Obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                Obj.NGAYSUA = DateTime.Now;
            }
            Obj.LOAI_DE_NGHI = Convert.ToDecimal(DropLoaiDeNghi.SelectedValue);
            Obj.TOAANID = Convert.ToDecimal(DropToaAn.SelectedValue);
            Obj.TEN_DANH_SACH = TxtTenDanSach.Text.Trim();
            Obj.NAM = TxtNam.Text.Trim() + "" == "" ? 0 : Convert.ToDecimal(TxtNam.Text);
            //Obj.SOQD = TxtSoQD.Text.Trim();
            //Obj.NGAYQD = TxtNgayQD.Text + "" == "" ? (DateTime?)null : DateTime.Parse(TxtNgayQD.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            Obj.NGUOI_LAP = TxtNguoiLap.Text;
            Obj.NGAYLAP = TxtNgayLap.Text + "" == "" ? (DateTime?)null : DateTime.Parse(TxtNgayLap.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            Obj.NGUOI_DUYET_TEN = TxtNguoiDuyet.Text.Trim();
            Obj.NGUOI_DUYET_CHUC_VU = TxtChucVu.Text.Trim();
            #region Tệp đính kèm
            //try
            //{
            //    if (hddFilePath.Value != "")
            //    {
            //        string strFilePath = hddFilePath.Value.Replace("/", "\\");
            //        FileInfo oF = new FileInfo(strFilePath);
            //        #region Lưu file
            //        byte[] buff = null;
            //        using (FileStream fs = File.OpenRead(strFilePath))
            //        {
            //            BinaryReader br = new BinaryReader(fs);
            //            long numBytes = oF.Length;
            //            buff = br.ReadBytes((int)numBytes);
            //            Obj.FILE_NOIDUNG = buff;
            //            Obj.FILE_TEN = Cls_Comon.ChuyenTenFileUpload(oF.Name);
            //            Obj.FILE_LOAI = oF.Extension;
            //        }
            //        #endregion
            //        File.Delete(strFilePath);
            //    }
            //}
            //catch { }
            #endregion
            if (ID == 0)
            {
                dt.TDKT_DANH_SACH.Add(Obj);
            }
            dt.SaveChanges();
            //
            hddID.Value = "0";
            ResetData();
            Lblthongbao.Text = "Lưu dữ liệu thành công.";
        }
        private bool CheckData()
        {
            decimal ToaAn = Convert.ToDecimal(DropToaAn.SelectedValue);
            if (ToaAn == 0)
            {
                DropToaAn.Focus();
                Lblthongbao.Text = "Chưa chọn đơn vị. Hãy chọn lại.";
                return false;
            }
            int Length = TxtTenDanSach.Text.Trim().Length;
            if (Length == 0)
            {
                TxtTenDanSach.Focus();
                Lblthongbao.Text = "Tên danh sách không được để trống. Hãy nhập lại.";
                return false;
            }
            else if (Length > 500)
            {
                TxtTenDanSach.Focus();
                Lblthongbao.Text = "Tên danh sách không được quá 500 ký tự. Hãy nhập lại.";
                return false;
            }
            decimal LoaiDeNghi = Convert.ToDecimal(DropLoaiDeNghi.SelectedValue);
            if (LoaiDeNghi == 0)
            {
                DropLoaiDeNghi.Focus();
                Lblthongbao.Text = "Chưa chọn loại đề nghị. Hãy chọn lại.";
                return false;
            }
            Length = TxtNam.Text.Trim().Length;
            if (Length == 0)
            {
                TxtNam.Focus();
                Lblthongbao.Text = "Năm phải là số có 04 chữ số. Hãy nhập lại.";
                return false;
            }
            if ((Length > 0 && Length < 4) || Length > 4)
            {
                TxtNam.Focus();
                Lblthongbao.Text = "Năm phải là số có 04 chữ số. Hãy nhập lại.";
                return false;
            }
            int Nam = Convert.ToInt32(TxtNam.Text);
            if (Nam > DateTime.Now.Year)
            {
                TxtNam.Focus();
                Lblthongbao.Text = "Năm không được lớn hơn năm hiện tại. Hãy nhập lại.";
                return false;
            }
            //Length = TxtSoQD.Text.Trim().Length;
            //if (Length == 0)
            //{
            //    TxtSoQD.Focus();
            //    Lblthongbao.Text = "Số QĐ không được để trống. Hãy nhập lại.";
            //    return false;
            //}
            //else if (Length > 100)
            //{
            //    TxtSoQD.Focus();
            //    Lblthongbao.Text = "Số QĐ không được quá 100 ký tự. Hãy nhập lại.";
            //    return false;
            //}
            //if (TxtNgayQD.Text.Trim() == "")
            //{
            //    TxtNgayQD.Focus();
            //    Lblthongbao.Text = "Ngày QĐ không được để trống. Hãy nhập lại.";
            //    return false;
            //}
            //else
            //{
            //    if (!Cls_Comon.IsValidDate(TxtNgayQD.Text))
            //    {
            //        TxtNgayQD.Focus();
            //        Lblthongbao.Text = "Ngày QĐ phải có kiểu ngày/tháng/năm. Hãy nhập lại.";
            //        return false;
            //    }
            //    DateTime NgayQD = Convert.ToDateTime(TxtNgayQD.Text, cul);
            //    if (NgayQD > DateTime.Now)
            //    {
            //        TxtNgayQD.Focus();
            //        Lblthongbao.Text = "Ngày QĐ phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại.";
            //        return false;
            //    }
            //}
            Length = TxtNguoiLap.Text.Trim().Length;
            if (Length > 250)
            {
                TxtNguoiLap.Focus();
                Lblthongbao.Text = "Tên người lập không quá 250 ký tự. Hãy nhập lại.";
                return false;
            }
            if (TxtNgayLap.Text != "")
            {
                if (!Cls_Comon.IsValidDate(TxtNgayLap.Text))
                {
                    TxtNgayLap.Focus();
                    Lblthongbao.Text = "Ngày lập phải có kiểu ngày/tháng/năm. Hãy nhập lại.";
                    return false;
                }
                DateTime NgayLap = Convert.ToDateTime(TxtNgayLap.Text, cul);
                if (NgayLap > DateTime.Now)
                {
                    TxtNgayLap.Focus();
                    Lblthongbao.Text = "Ngày lập phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại.";
                    return false;
                }
            }
            Length = TxtNguoiDuyet.Text.Trim().Length;
            if (Length > 250)
            {
                TxtNguoiDuyet.Focus();
                Lblthongbao.Text = "Tên người duyệt không quá 250 ký tự. Hãy nhập lại.";
                return false;
            }
            Length = TxtChucVu.Text.Trim().Length;
            if (Length > 250)
            {
                TxtChucVu.Focus();
                Lblthongbao.Text = "Chức vụ không quá 250 ký tự. Hãy nhập lại.";
                return false;
            }
            return true;
        }
        private bool CheckExist()
        {
            decimal ToaAnID = Convert.ToDecimal(DropToaAn.SelectedValue)
                    , LoaiDeNghi = Convert.ToDecimal(DropLoaiDeNghi.SelectedValue);
            TDKT_DANH_SACH Obj = dt.TDKT_DANH_SACH.Where(x => x.TOAANID == ToaAnID && x.TEN_DANH_SACH.ToLower() == TxtTenDanSach.Text.Trim().ToLower() && x.LOAI_DE_NGHI == LoaiDeNghi).FirstOrDefault();
            if (Obj != null)
            {
                if (Obj.ID + "" != hddID.Value)
                {
                    return false;
                }
            }
            return true;
        }

    }
}