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

namespace WEB.GSTP.TDKT.Ketquabinhxet
{
    public partial class Edit : System.Web.UI.Page
    {
        private const decimal THIDUA = 1, KHENTHUONG = 2, KYLUAT = 3;
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
                    decimal DanhSachID = Request["ds"] + "" == "" ? 0 : Convert.ToDecimal(Request["ds"]);
                    hddDanhsachID.Value = DanhSachID.ToString();
                    LoadKetQua(DanhSachID);
                    hddPageIndex.Value = "1";
                    LoadDSDoiTuong();
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadDSDoiTuong()
        {
            int pageSize = Convert.ToInt32(HddPageSize.Value),
                pageIndex = Convert.ToInt32(hddPageIndex.Value);
            decimal DanhSachID = Convert.ToDecimal(hddDanhsachID.Value);
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("IN_DANHSACH",DanhSachID),
                new OracleParameter("IN_PAGESIZE",pageSize),
                new OracleParameter("IN_PAGEINDEX",pageIndex),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("TDKT_GET_DOI_TUONG_BINH_XET", parameters);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["Total"].ToString());
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,0.###", cul)
                                                        + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            dgList.PageSize = pageSize;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadDSDoiTuong();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDSDoiTuong();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDSDoiTuong();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDSDoiTuong();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDSDoiTuong();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        #endregion
        private void LoadKetQua(decimal DanhSachID)
        {
            TDKT_KET_QUA_BINH_XET ObjKetQua = dt.TDKT_KET_QUA_BINH_XET.Where(x => x.DANH_SACH_ID == DanhSachID).FirstOrDefault();
            if (ObjKetQua != null)
            {
                TxtNgayBatDau.Text = ObjKetQua.NGAY_BAT_DAU + "" == "" ? "" : ((DateTime)ObjKetQua.NGAY_BAT_DAU).ToString("dd/MM/yyyy");
                TxtNgayKetThuc.Text = ObjKetQua.NGAY_KET_THUC + "" == "" ? "" : ((DateTime)ObjKetQua.NGAY_KET_THUC).ToString("dd/MM/yyyy");
                TxtDiaDiem.Text = ObjKetQua.DIA_DIEM;
                TxtThanhPhanThamDu.Text = ObjKetQua.THANH_PHAN_THAM_DU;
                TxtChuTri.Text = ObjKetQua.CHU_TRI;
                TxtChuTri_CV.Text = ObjKetQua.CHU_TRI_CHUC_VU;
                TxtThuKy.Text = ObjKetQua.THU_KY;
                TxtThuKy_CV.Text = ObjKetQua.THU_KY_CHUC_VU;
                TxtNoiDung.Text = ObjKetQua.NOI_DUNG;
                TxtYKien.Text = ObjKetQua.Y_KIEN;
                TxtKetQua.Text = ObjKetQua.KET_QUA;
                //LbtDownload.Text = ObjKetQua.FILE_TEN;
                //if (ObjKetQua.FILE_TEN + "" != "")
                //{
                //    ImgXoa.Visible = true;
                //}
                //else
                //{
                //    ImgXoa.Visible = false;
                //}
                BtnXoa.Visible = true;
            }
            else { BtnXoa.Visible = false; }
        }
        private void LoadDropHinhThuc_KQ(DropDownList DropLoaiDeNghi_KQ, DropDownList DropHinhThuc_KQ)
        {
            DropHinhThuc_KQ.Items.Clear();
            decimal LoaiDeNghi = Convert.ToDecimal(DropLoaiDeNghi_KQ.SelectedValue);
            string GroupName = "";
            if (LoaiDeNghi == KYLUAT)
            {
                GroupName = ENUM_DANHMUC.DM_HINHTHUC_KYLUAT;
            }
            else if (LoaiDeNghi == KHENTHUONG)
            {
                GroupName = ENUM_DANHMUC.DM_HINHTHUC_KHENTHUONG;
            }
            else if (LoaiDeNghi == THIDUA)
            {
                GroupName = ENUM_DANHMUC.DM_DANHHIEU_THIDUA;
            }
            if (GroupName != "")
            {
                DM_DATAITEM_BL bl = new DM_DATAITEM_BL();
                DataTable tbl = bl.DM_DATAITEM_GETBYGROUPNAME(GroupName);
                if (tbl.Rows.Count > 0)
                {
                    DropHinhThuc_KQ.DataSource = tbl;
                    DropHinhThuc_KQ.DataTextField = "TEN";
                    DropHinhThuc_KQ.DataValueField = "ID";
                    DropHinhThuc_KQ.DataBind();
                }
            }
            if (DropHinhThuc_KQ.Items.Count == 0)
                DropHinhThuc_KQ.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        //protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        //{
        //    try
        //    {
        //        if (AsyncFileUpLoad.HasFile)
        //        {
        //            string strFileName = AsyncFileUpLoad.FileName;
        //            string path = Server.MapPath("~/TempUpload/") + strFileName;
        //            AsyncFileUpLoad.SaveAs(path);
        //            path = path.Replace("\\", "/");
        //            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
        //        }
        //    }
        //    catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        //}
        protected void BtnXoa_Click(object sender, EventArgs e)
        {
            decimal DanhSachID = Convert.ToDecimal(hddDanhsachID.Value);
            TDKT_KET_QUA_BINH_XET Obj = dt.TDKT_KET_QUA_BINH_XET.Where(x => x.DANH_SACH_ID == DanhSachID).FirstOrDefault();
            if (Obj != null)
            {
                List<TDKT_KET_QUA_BX_DT> lst = dt.TDKT_KET_QUA_BX_DT.Where(x => x.KET_QUA_ID == Obj.ID).ToList();
                dt.TDKT_KET_QUA_BX_DT.RemoveRange(lst);
                dt.TDKT_KET_QUA_BINH_XET.Remove(Obj);
                dt.SaveChanges();
                //
                TxtNgayBatDau.Text = "";
                TxtNgayKetThuc.Text = "";
                TxtDiaDiem.Text = "";
                TxtThanhPhanThamDu.Text = "";
                TxtChuTri.Text = "";
                TxtChuTri_CV.Text = "";
                TxtThuKy.Text = "";
                TxtThuKy_CV.Text = "";
                TxtNoiDung.Text = "";
                TxtYKien.Text = "";
                TxtKetQua.Text = "";
                //LbtDownload.Text = "";
                //hddFilePath.Value = "";
                //ImgXoa.Visible = false;
                LoadDSDoiTuong();
                //
                Lblthongbao.Text = "Xóa kết quả bình xét thành công.";
            }
        }
        protected void BtnLuu_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckInputData())
                {
                    return;
                }
                // Lưu kết quả
                bool IsNew = false;
                decimal DanhSachID = Convert.ToDecimal(hddDanhsachID.Value);
                TDKT_KET_QUA_BINH_XET Obj = dt.TDKT_KET_QUA_BINH_XET.Where(x => x.DANH_SACH_ID == DanhSachID).FirstOrDefault();
                if (Obj == null)
                {
                    IsNew = true;
                    Obj = new TDKT_KET_QUA_BINH_XET();
                    Obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    Obj.NGAYTAO = DateTime.Now;
                }
                else
                {
                    Obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    Obj.NGAYSUA = DateTime.Now;
                }
                Obj.DANH_SACH_ID = DanhSachID;
                Obj.NGAY_BAT_DAU = TxtNgayBatDau.Text + "" == "" ? (DateTime?)null : DateTime.Parse(TxtNgayBatDau.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                Obj.NGAY_KET_THUC = TxtNgayKetThuc.Text + "" == "" ? (DateTime?)null : DateTime.Parse(TxtNgayKetThuc.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                Obj.DIA_DIEM = TxtDiaDiem.Text.Trim();
                Obj.THANH_PHAN_THAM_DU = TxtThanhPhanThamDu.Text.Trim();
                Obj.CHU_TRI = TxtChuTri.Text.Trim();
                Obj.CHU_TRI_CHUC_VU = TxtChuTri_CV.Text.Trim();
                Obj.THU_KY = TxtThuKy.Text.Trim();
                Obj.THU_KY_CHUC_VU = TxtThuKy_CV.Text.Trim();
                Obj.NOI_DUNG = TxtNoiDung.Text.Trim();
                Obj.Y_KIEN = TxtYKien.Text.Trim();
                Obj.KET_QUA = TxtKetQua.Text.Trim();
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
                if (IsNew)
                    dt.TDKT_KET_QUA_BINH_XET.Add(Obj);
                dt.SaveChanges();
                // Lưu các đối tượng
                TDKT_KET_QUA_BX_DT ObjDoiTuong = null;
                HiddenField hddDoiTuongID;
                DropDownList DropLoaiDeNghi_KQ, DropHinhThuc_KQ;
                decimal DoiTuongID = 0, KetQuaID = Obj.ID;
                foreach (DataGridItem item in dgList.Items)
                {
                    IsNew = false;
                    DropLoaiDeNghi_KQ = (DropDownList)item.FindControl("DropLoaiDeNghi_KQ");
                    DropHinhThuc_KQ = (DropDownList)item.FindControl("DropHinhThuc_KQ");
                    hddDoiTuongID = (HiddenField)item.FindControl("hddDoiTuongID");
                    DoiTuongID = Convert.ToDecimal(hddDoiTuongID.Value);
                    ObjDoiTuong = dt.TDKT_KET_QUA_BX_DT.Where(x => x.KET_QUA_ID == KetQuaID && x.DOI_TUONG_ID == DoiTuongID).FirstOrDefault();
                    if (ObjDoiTuong == null)
                    {
                        IsNew = true;
                        ObjDoiTuong = new TDKT_KET_QUA_BX_DT();
                    }
                    ObjDoiTuong.KET_QUA_ID = KetQuaID;
                    ObjDoiTuong.DOI_TUONG_ID = DoiTuongID;
                    ObjDoiTuong.LOAI_DE_NGHI_KET_QUA = Convert.ToDecimal(DropLoaiDeNghi_KQ.SelectedValue);
                    ObjDoiTuong.HINH_THUC_KET_QUA_ID = Convert.ToDecimal(DropHinhThuc_KQ.SelectedValue);
                    if (IsNew)
                        dt.TDKT_KET_QUA_BX_DT.Add(ObjDoiTuong);
                    dt.SaveChanges();
                }
                Lblthongbao.Text = "Lưu thành công.";
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void ImgXoa_Click(object sender, ImageClickEventArgs e)
        {
            decimal DanhSachID = Convert.ToDecimal(hddDanhsachID.Value);
            TDKT_KET_QUA_BINH_XET Obj = dt.TDKT_KET_QUA_BINH_XET.Where(x => x.DANH_SACH_ID == DanhSachID).FirstOrDefault<TDKT_KET_QUA_BINH_XET>();
            if (Obj != null)
            {
                Obj.FILE_LOAI = "";
                Obj.FILE_NOIDUNG = null;
                Obj.FILE_TEN = "";
                dt.SaveChanges();
            }
            //hddFilePath.Value = "";
            //ImgXoa.Visible = false;
            //LbtDownload.Text = "";
        }
        protected void DropLoaiDeNghi_KQ_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList DropLoaiDeNghi_KQ = (DropDownList)sender;
            DataGridItem gridrow = (DataGridItem)DropLoaiDeNghi_KQ.NamingContainer;
            int rowIndex = gridrow.ItemIndex;
            foreach (DataGridItem item in dgList.Items)
            {
                if (item.ItemIndex == rowIndex)
                {
                    DropDownList DropHinhThuc_KQ = (DropDownList)item.FindControl("DropHinhThuc_KQ");
                    LoadDropHinhThuc_KQ(DropLoaiDeNghi_KQ, DropHinhThuc_KQ);
                }
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                DropDownList DropLoaiDeNghi_KQ = (DropDownList)e.Item.FindControl("DropLoaiDeNghi_KQ");
                DropDownList DropHinhThuc_KQ = (DropDownList)e.Item.FindControl("DropHinhThuc_KQ");
                Label LblLoaiDeNghi = (Label)e.Item.FindControl("LblLoaiDeNghi");
                decimal LoaiDeNghi = rowView["LOAIDENGHI"] + "" == "" ? 0 : Convert.ToDecimal(rowView["LOAIDENGHI"] + "");
                if (LoaiDeNghi == KHENTHUONG)
                    LblLoaiDeNghi.Text = "Khen thưởng";
                else if (LoaiDeNghi == KYLUAT)
                    LblLoaiDeNghi.Text = "Kỷ luật";
                else if (LoaiDeNghi == THIDUA)
                    LblLoaiDeNghi.Text = "Thi đua";
                DropLoaiDeNghi_KQ.SelectedValue = LoaiDeNghi.ToString();
                LoadDropHinhThuc_KQ(DropLoaiDeNghi_KQ, DropHinhThuc_KQ);
                DropHinhThuc_KQ.SelectedValue = rowView["HINHTHUC_ID"] + "";
            }
        }
        protected void BtnQuayLai_Click(object sender, EventArgs e)
        {
            string link = Cls_Comon.GetRootURL() + "/TDKT/Ketquabinhxet/Danhsach.aspx?pag=" + Request["pag"];
            Response.Redirect(link);
        }
        //protected void LbtDownload_Click(object sender, EventArgs e)
        //{
        //    decimal DanhSachID = Convert.ToDecimal(hddDanhsachID.Value);
        //    TDKT_KET_QUA_BINH_XET Obj = dt.TDKT_KET_QUA_BINH_XET.Where(x => x.DANH_SACH_ID == DanhSachID).FirstOrDefault();
        //    if (Obj.FILE_TEN != "")
        //    {
        //        var cacheKey = Guid.NewGuid().ToString("N");
        //        Context.Cache.Insert(key: cacheKey, value: Obj.FILE_NOIDUNG, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
        //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + Obj.FILE_TEN + "&Extension=" + Obj.FILE_LOAI + "';", true);
        //    }
        //}
        private bool CheckInputData()
        {
            int Length = TxtNgayBatDau.Text.Length;
            if (Length == 0)
            {
                Lblthongbao.Text = "Ngày bắt đầu không được để trống. Hãy nhập lại";
                TxtNgayBatDau.Focus();
                return false;
            }
            else
            {
                if (!Cls_Comon.IsValidDate(TxtNgayBatDau.Text))
                {
                    TxtNgayBatDau.Focus();
                    Lblthongbao.Text = "Ngày bắt đầu phải có kiểu ngày/tháng/năm. Hãy nhập lại.";
                    return false;
                }
                DateTime NgayBatDau = Convert.ToDateTime(TxtNgayBatDau.Text, cul);
                if (NgayBatDau > DateTime.Now)
                {
                    TxtNgayBatDau.Focus();
                    Lblthongbao.Text = "Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại.";
                    return false;
                }
                Length = TxtNgayKetThuc.Text.Length;
                if (Length == 0)
                {
                    Lblthongbao.Text = "Ngày Kết thúc không được để trống. Hãy nhập lại";
                    TxtNgayBatDau.Focus();
                    return false;
                }
                else
                {
                    if (!Cls_Comon.IsValidDate(TxtNgayKetThuc.Text))
                    {
                        TxtNgayKetThuc.Focus();
                        Lblthongbao.Text = "Ngày kết thúc phải có kiểu ngày/tháng/năm. Hãy nhập lại.";
                        return false;
                    }
                    DateTime NgayKetThuc = Convert.ToDateTime(TxtNgayKetThuc.Text, cul);
                    if (NgayKetThuc > DateTime.Now)
                    {
                        TxtNgayKetThuc.Focus();
                        Lblthongbao.Text = "Ngày kết thúc phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại.";
                        return false;
                    }
                    if (NgayBatDau > NgayKetThuc)
                    {
                        TxtNgayKetThuc.Focus();
                        Lblthongbao.Text = "Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu. Hãy nhập lại.";
                        return false;
                    }
                }
            }
            Length = TxtDiaDiem.Text.Trim().Length;
            if (Length > 500)
            {
                TxtDiaDiem.Focus();
                Lblthongbao.Text = "Địa điểm không quá 500 ký tự. Hãy nhập lại.";
                return false;
            }
            Length = TxtThanhPhanThamDu.Text.Trim().Length;
            if (Length == 0)
            {
                TxtThanhPhanThamDu.Focus();
                Lblthongbao.Text = "Thành phần tham dự không được để trống. Hãy nhập lại.";
                return false;
            }
            if (Length > 4000)
            {
                TxtThanhPhanThamDu.Focus();
                Lblthongbao.Text = "Thành phần tham dự không quá 4000 ký tự. Hãy nhập lại.";
                return false;
            }
            Length = TxtChuTri.Text.Trim().Length;
            if (Length == 0)
            {
                TxtChuTri.Focus();
                Lblthongbao.Text = "Chủ trì cuộc họp không được để trống. Hãy nhập lại.";
                return false;
            }
            if (Length > 250)
            {
                TxtChuTri.Focus();
                Lblthongbao.Text = "Chủ trì cuộc họp không quá 250 ký tự. Hãy nhập lại.";
                return false;
            }
            Length = TxtChuTri_CV.Text.Trim().Length;
            if (Length > 250)
            {
                TxtChuTri_CV.Focus();
                Lblthongbao.Text = "Chức vụ của chủ trì cuộc họp không quá 250 ký tự. Hãy nhập lại.";
                return false;
            }
            Length = TxtThuKy.Text.Trim().Length;
            if (Length == 0)
            {
                TxtThuKy.Focus();
                Lblthongbao.Text = "Thư ký cuộc họp không được để trống. Hãy nhập lại.";
                return false;
            }
            if (Length > 250)
            {
                TxtThuKy.Focus();
                Lblthongbao.Text = "Thư ký cuộc họp không quá 250 ký tự. Hãy nhập lại.";
                return false;
            }
            Length = TxtThuKy_CV.Text.Trim().Length;
            if (Length > 250)
            {
                TxtThuKy_CV.Focus();
                Lblthongbao.Text = "Chức vụ của thư ký cuộc họp không quá 250 ký tự. Hãy nhập lại.";
                return false;
            }
            Length = TxtNoiDung.Text.Trim().Length;
            if (Length == 0)
            {
                TxtNoiDung.Focus();
                Lblthongbao.Text = "Nội dung cuộc họp không được để trống. Hãy nhập lại.";
                return false;
            }
            if (Length > 250)
            {
                TxtNoiDung.Focus();
                Lblthongbao.Text = "Nội dung cuộc họp không quá 250 ký tự. Hãy nhập lại.";
                return false;
            }
            Length = TxtYKien.Text.Trim().Length;
            if (Length > 4000)
            {
                TxtYKien.Focus();
                Lblthongbao.Text = "Ý kiếm tham gia không quá 4000 ký tự. Hãy nhập lại.";
                return false;
            }
            Length = TxtKetQua.Text.Trim().Length;
            if (Length == 0)
            {
                TxtKetQua.Focus();
                Lblthongbao.Text = "Kết quả cuộc họp không được để trống. Hãy nhập lại.";
                return false;
            }
            if (Length > 4000)
            {
                TxtKetQua.Focus();
                Lblthongbao.Text = "Kết quả cuộc họp không quá 4000 ký tự. Hãy nhập lại.";
                return false;
            }
            return true;
        }
    }
}