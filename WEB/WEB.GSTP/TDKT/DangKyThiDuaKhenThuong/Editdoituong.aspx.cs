using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.TDKT.DangKyThiDuaKhenThuong
{
    public partial class Editdoituong : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        private const int TAPTHE = 1, CANHAN = 2, THIDUA = 1, KHENTHUONG = 2, KYLUAT = 3;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                if (!IsPostBack)
                {
                    decimal DanhSachID = 0;
                    decimal.TryParse(Request["ds"] + "", out DanhSachID);
                    LoadDropDonVi(DanhSachID);
                    LoadDropPhongBan();
                    LoadDropDropCanBo();
                    LoadDropLoaiDeNghi(DanhSachID);
                    LoadDropLoaiHinhKT();
                    LoadDropHinhThuc();
                    hddID.Value = Request["dt"] + "" == "" ? "0" : Request["dt"] + "";
                    decimal ID = 0;
                    if (decimal.TryParse(hddID.Value, out ID))
                    {
                        hddID.Value = ID.ToString();
                    }
                    LoadInfo(ID);
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadDropDonVi(decimal DanhSachID)
        {
            decimal ToaAnID = 0;
            TDKT_DANH_SACH ObjDS = dt.TDKT_DANH_SACH.Where(x => x.ID == DanhSachID).FirstOrDefault();
            if (ObjDS != null)
            {
                ToaAnID = (decimal)ObjDS.TOAANID;
            }
            DM_TOAAN ObjTA = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
            if (ObjTA != null)
            {
                DropDonVi.Items.Add(new ListItem(ObjTA.TEN, ToaAnID.ToString()));
            }
            else
            {
                DropDonVi.Items.Add(new ListItem("--- Chọn ---", "0"));
            }
        }
        private void LoadDropPhongBan()
        {
            DropPhongBan.Items.Clear();
            decimal ToaAnID = Convert.ToDecimal(DropDonVi.SelectedValue);
            List<DM_PHONGBAN> lst = dt.DM_PHONGBAN.Where(x => x.TOAANID == ToaAnID).OrderBy(x => x.THUTU).ToList();
            if (lst.Count > 0)
            {
                DropPhongBan.DataSource = lst;
                DropPhongBan.DataTextField = "TENPHONGBAN";
                DropPhongBan.DataValueField = "ID";
                DropPhongBan.DataBind();
            }
            DropPhongBan.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadDropDropCanBo()
        {
            DropCanBo.Items.Clear();
            decimal ToaAnID = Convert.ToDecimal(DropDonVi.SelectedValue);
            List<DM_CANBO> lst = dt.DM_CANBO.Where(x => x.TOAANID == ToaAnID).OrderBy(x => x.HOTEN).ToList();
            if (lst.Count > 0)
            {
                DropCanBo.DataSource = lst;
                DropCanBo.DataTextField = "HOTEN";
                DropCanBo.DataValueField = "ID";
                DropCanBo.DataBind();
            }
            DropCanBo.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            DropCanBo_SelectedIndexChanged(new object(), new EventArgs());
        }
        private void LoadDropLoaiDeNghi(decimal DanhSachID)
        {
            decimal LoaiDeNghi = 0;
            TDKT_DANH_SACH ObjDS = dt.TDKT_DANH_SACH.Where(x => x.ID == DanhSachID).FirstOrDefault();
            if (ObjDS != null)
            {
                LoaiDeNghi = (decimal)ObjDS.LOAI_DE_NGHI;
            }
            if (LoaiDeNghi == KYLUAT)
            {
                DropLoaiDeNghi.Items.Add(new ListItem("Kỷ luật", "3"));
            }
            else if (LoaiDeNghi == KHENTHUONG)
            {
                DropLoaiDeNghi.Items.Add(new ListItem("Khen thưởng", "2"));
                PnlLoaiHinhKT.Visible = true;
            }
            else if (LoaiDeNghi == THIDUA)
            {
                DropLoaiDeNghi.Items.Add(new ListItem("Thi đua", "1"));
            }
            else
            {
                DropLoaiDeNghi.Items.Add(new ListItem("--- Chọn ---", "0"));
            }
            DropLoaiDeNghi_SelectedIndexChanged(new object(), new EventArgs());
        }
        private void LoadDropLoaiHinhKT()
        {
            string GroupName = ENUM_DANHMUC.DM_LOAIHINH_KHENTHUONG;
            DM_DATAITEM_BL bl = new DM_DATAITEM_BL();
            DataTable tbl = bl.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (tbl.Rows.Count > 0)
            {
                DropLoaiHinhKT.DataSource = tbl;
                DropLoaiHinhKT.DataTextField = "TEN";
                DropLoaiHinhKT.DataValueField = "ID";
                DropLoaiHinhKT.DataBind();
            }
            DropLoaiHinhKT.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadDropHinhThuc()
        {
            DropHinhThuc.Items.Clear();
            int LoaiDeNghi = Convert.ToInt32(DropLoaiDeNghi.SelectedValue);
            string GroupName = "";
            if (LoaiDeNghi == KHENTHUONG)
            {
                GroupName = ENUM_DANHMUC.DM_HINHTHUC_KHENTHUONG;
            }
            else if (LoaiDeNghi == KYLUAT)
            {
                GroupName = ENUM_DANHMUC.DM_HINHTHUC_KYLUAT;
            }
            else if (LoaiDeNghi == THIDUA)
            {
                GroupName = ENUM_DANHMUC.DM_DANHHIEU_THIDUA;
            }
            DM_DATAITEM_BL bl = new DM_DATAITEM_BL();
            DataTable tbl = bl.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (tbl.Rows.Count > 0)
            {
                DropHinhThuc.DataSource = tbl;
                DropHinhThuc.DataTextField = "TEN";
                DropHinhThuc.DataValueField = "ID";
                DropHinhThuc.DataBind();
            }
            DropHinhThuc.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        protected void DropCanBo_SelectedIndexChanged(object sender, EventArgs e)
        {
            TxtChucVu.Text = "";
            decimal CanBoID = Convert.ToDecimal(DropCanBo.SelectedValue);
            DM_CANBO ObjCB = dt.DM_CANBO.Where(x => x.ID == CanBoID).FirstOrDefault();
            if (ObjCB != null)
            {
                decimal ChucVuID = ObjCB.CHUCVUID + "" == "" ? 0 : (decimal)ObjCB.CHUCVUID;
                DM_DATAITEM ObjCV = dt.DM_DATAITEM.Where(x => x.ID == ChucVuID).FirstOrDefault();
                if (ObjCV != null)
                {
                    TxtChucVu.Text = ObjCV.TEN;
                }
            }
        }
        protected void DropLoaiDeNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                PnlLoaiHinhKT.Visible = false;
                int LoaiDeNghi = Convert.ToInt32(DropLoaiDeNghi.SelectedValue);
                if (LoaiDeNghi == KYLUAT)
                {
                    LtrTitleNoiDung.Text = "Mô tả lỗi vi phạm";
                    LtrTitleHinhThuc.Text = "Hình thức kỷ luật";
                }
                else if (LoaiDeNghi == KHENTHUONG)
                {
                    LtrTitleNoiDung.Text = "Mô tả thành tích";
                    LtrTitleHinhThuc.Text = "Hình thức khen thưởng";
                    PnlLoaiHinhKT.Visible = true;
                }
                else if (LoaiDeNghi == THIDUA)
                {
                    LtrTitleNoiDung.Text = "Mô tả thành tích";
                    LtrTitleHinhThuc.Text = "Danh hiệu thi đua";
                }
                else
                {
                    LtrTitleNoiDung.Text = "Mô tả thành tích";
                    LtrTitleHinhThuc.Text = "Hình thức";
                }
                LoadDropHinhThuc();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void DropLoaiDoiTuong_SelectedIndexChanged(object sender, EventArgs e)
        {
            int LoaiDoiTuong = Convert.ToInt32(DropLoaiDoiTuong.SelectedValue);
            if (LoaiDoiTuong == CANHAN)
            {
                PnlCaNhan.Visible = true;
                PnlTapThe.Visible = false;
                DropPhongBan.SelectedIndex = 0;
            }
            else if (LoaiDoiTuong == TAPTHE)
            {
                PnlCaNhan.Visible = false;
                PnlTapThe.Visible = true;
                DropCanBo.SelectedIndex = 0;
            }
            else
            {
                PnlCaNhan.Visible = false;
                PnlTapThe.Visible = false;
                DropPhongBan.SelectedIndex = 0;
                DropCanBo.SelectedIndex = 0;
            }
        }
        private void LoadInfo(decimal ID)
        {
            Lblthongbao.Text = "";
            TDKT_DANH_SACH_DOI_TUONG Obj = dt.TDKT_DANH_SACH_DOI_TUONG.Where(x => x.ID == ID).FirstOrDefault<TDKT_DANH_SACH_DOI_TUONG>();
            if (Obj != null)
            {
                PnlLoaiHinhKT.Visible = false;
                DropLoaiDoiTuong.SelectedValue = Obj.LOAI_DOI_TUONG + "";
                DropDonVi.SelectedValue = Obj.DONVIID + "";
                DM_TOAAN ObjTA = dt.DM_TOAAN.Where(x => x.ID == Obj.DONVIID).FirstOrDefault();
                if (ObjTA != null)
                {
                    DropDonVi.Items.Add(new ListItem(ObjTA.TEN, Obj.DONVIID.ToString()));
                }
                else
                {
                    DropDonVi.Items.Add(new ListItem("--- Chọn ---", "0"));
                }
                if (Obj.LOAI_DOI_TUONG == TAPTHE)
                {
                    PnlTapThe.Visible = true;
                    PnlCaNhan.Visible = false;
                    DropPhongBan.SelectedValue = Obj.PHONG_BAN + "";
                }
                if (Obj.LOAI_DOI_TUONG == CANHAN)
                {
                    PnlTapThe.Visible = false;
                    PnlCaNhan.Visible = true;
                    DropCanBo.SelectedValue = Obj.CAN_BO_ID + "";
                    TxtChucVu.Text = Obj.CAN_BO_CHUC_VU;
                }
                DropLoaiDeNghi.SelectedValue = Obj.LOAI_DE_NGHI + "";
                if (Obj.LOAI_DE_NGHI == KYLUAT)
                {
                    LtrTitleNoiDung.Text = "Mô tả lỗi vi phạm";
                    LtrTitleHinhThuc.Text = "Hình thức kỷ luật";
                }
                else if (Obj.LOAI_DE_NGHI == KHENTHUONG)
                {
                    LtrTitleNoiDung.Text = "Mô tả thành tích";
                    LtrTitleHinhThuc.Text = "Hình thức khen thưởng";
                    PnlLoaiHinhKT.Visible = true;
                }
                else if (Obj.LOAI_DE_NGHI == THIDUA)
                {
                    LtrTitleNoiDung.Text = "Mô tả thành tích";
                    LtrTitleHinhThuc.Text = "Danh hiệu thi đua";
                }
                else
                {
                    LtrTitleNoiDung.Text = "Mô tả thành tích";
                    LtrTitleHinhThuc.Text = "Hình thức";
                }
                LoadDropHinhThuc();
                DropHinhThuc.SelectedValue = Obj.HINH_THUC_ID + "";
                DropLoaiHinhKT.SelectedValue = Obj.LOAI_HINH_KT + "" == "" ? "0" : Obj.LOAI_HINH_KT + "";
                TxtNoiDung.Text = Obj.NOI_DUNG;
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
        private void SaveData()
        {
            if (!CheckData())
            {
                return;
            }
            decimal DanhsachID = Request["ds"] + "" == "" ? 0 : Convert.ToDecimal(Request["ds"] + ""),
                    CanBoID = 0, PhongBan = 0, ID = Convert.ToDecimal(hddID.Value),
                    DonVi = Convert.ToDecimal(DropDonVi.SelectedValue),
                    HinhThuc = Convert.ToDecimal(DropHinhThuc.SelectedValue),
                    LoaiDeNghi = Convert.ToInt32(DropLoaiDeNghi.SelectedValue),
                    LoaiDoiTuong = Convert.ToInt32(DropLoaiDoiTuong.SelectedValue),
                    LoaiHinhKT = Convert.ToInt32(DropLoaiHinhKT.SelectedValue);
            string TenDoiTuong = "", ChucVu = "";
            if (PnlCaNhan.Visible)
            {
                CanBoID = Convert.ToDecimal(DropCanBo.SelectedValue);
                ChucVu = TxtChucVu.Text.Trim();
            }
            if (PnlTapThe.Visible)
            {
                PhongBan = Convert.ToDecimal(DropPhongBan.SelectedValue);
            }

            if (CanBoID > 0)
            {
                TenDoiTuong = DropCanBo.SelectedItem.Text;
            }
            if (PhongBan > 0)
            {
                TenDoiTuong = DropPhongBan.SelectedItem.Text;
            }
            if (CanBoID == 0 && PhongBan == 0)
            {
                TenDoiTuong = DropDonVi.SelectedItem.Text;
            }
            TDKT_DANH_SACH_DOI_TUONG Obj = dt.TDKT_DANH_SACH_DOI_TUONG.Where(x => x.ID == ID).FirstOrDefault<TDKT_DANH_SACH_DOI_TUONG>();
            if (Obj == null)
            {
                Obj = new TDKT_DANH_SACH_DOI_TUONG();
            }
            Obj.TEN_DOI_TUONG = TenDoiTuong;
            Obj.DANH_SACH_ID = DanhsachID;
            Obj.CAN_BO_ID = CanBoID;
            Obj.CAN_BO_CHUC_VU = ChucVu;
            Obj.DONVIID = DonVi;
            Obj.LOAI_DE_NGHI = LoaiDeNghi;
            Obj.LOAI_HINH_KT = LoaiHinhKT;
            Obj.HINH_THUC_ID = HinhThuc;
            Obj.NOI_DUNG = TxtNoiDung.Text;
            Obj.LOAI_DOI_TUONG = LoaiDoiTuong;
            Obj.PHONG_BAN = PhongBan;
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
                dt.TDKT_DANH_SACH_DOI_TUONG.Add(Obj);
            }
            dt.SaveChanges();
            //
            hddID.Value = "0";
            ResetData();
            Lblthongbao.Text = "Lưu dữ liệu thành công.";
        }
        private bool CheckData()
        {
            if (DropLoaiDoiTuong.SelectedValue == "0")
            {
                Lblthongbao.Text = "Chưa chọn loại đối tượng. Hãy chọn lại!";
                DropLoaiDoiTuong.Focus();
                return false;
            }
            int LoaiDoiTuong = Convert.ToInt32(DropLoaiDoiTuong.SelectedValue);
            if (LoaiDoiTuong == CANHAN)
            {
                if (DropCanBo.SelectedValue == "0")
                {
                    Lblthongbao.Text = "Chưa chọn cán bộ. Hãy chọn lại!";
                    DropCanBo.Focus();
                    return false;
                }
                if (TxtChucVu.Text.Trim().Length > 250)
                {
                    Lblthongbao.Text = "Chức vụ của cán bộ không quá 250 ký tự. Hãy nhập lại!";
                    TxtChucVu.Focus();
                    return false;
                }
            }
            if (DropHinhThuc.SelectedValue == "0")
            {
                int LoaiDeNghi = Convert.ToInt32(DropLoaiDeNghi.SelectedValue);
                if (LoaiDeNghi == KYLUAT)
                {
                    Lblthongbao.Text = "Chưa chọn hình thức kỷ luật. Hãy chọn lại!";
                }
                else if (LoaiDeNghi == KHENTHUONG)
                {
                    Lblthongbao.Text = "Chưa chọn hình thức khen thưởng. Hãy chọn lại!";
                }
                else if (LoaiDeNghi == THIDUA)
                {
                    Lblthongbao.Text = "Chưa chọn danh hiệu thi đua. Hãy chọn lại!";
                }
                DropHinhThuc.Focus();
                return false;
            }
            return true;
        }
        private void ResetData()
        {
            Lblthongbao.Text = "";
            DropLoaiDoiTuong.SelectedIndex = 0;
            DropLoaiDoiTuong_SelectedIndexChanged(new object(), new EventArgs());
            if (PnlTapThe.Visible)
            {
                DropPhongBan.SelectedIndex = 0;
            }
            if (PnlCaNhan.Visible)
            {
                DropCanBo.SelectedIndex = 0;
            }
            DropLoaiDeNghi.SelectedIndex = 0;
            DropLoaiDeNghi_SelectedIndexChanged(new object(), new EventArgs());
            DropLoaiHinhKT.SelectedIndex = 0;
            DropHinhThuc.SelectedIndex = 0;
            TxtNoiDung.Text = "";
            #region Tệp đính kèm
            //LbtDownload.Text = "";
            //ImgXoa.Visible = false;
            #endregion
        }
        protected void BtnLuu_Click(object sender, EventArgs e)
        {
            try
            {
                SaveData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void BtnQuayLai_Click(object sender, EventArgs e)
        {
            string link = Cls_Comon.GetRootURL() + "/TDKT/DangKyThiDuaKhenThuong/Danhsachdoituong.aspx?pag=" + Request["pag"] + "&dv=" + DropDonVi.SelectedValue + "&ds=" + Request["ds"] + "&ldn=" + Request["ldn"];
            Response.Redirect(link);
        }
        protected void BtnLamMoi_Click(object sender, EventArgs e)
        {
            ResetData();
        }
    }
}