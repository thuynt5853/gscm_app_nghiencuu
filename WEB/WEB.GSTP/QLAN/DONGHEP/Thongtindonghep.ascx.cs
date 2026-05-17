using BL.GSTP.DONGHEP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.DONGHEP
{
    public partial class Thongtindonghep : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal DONID;
        public Decimal LOAIANID;
        public decimal IdDonGhep;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadGrid();
            }
        }

        public void LoadGrid()
        {
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string keyDonID = "THONGTIN.DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            string keyLoaiAnId = "THONGTIN.DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            DONID = Convert.ToDecimal(Session[keyDonID]);
            LOAIANID = Convert.ToDecimal(Session[keyLoaiAnId]);
            int page_size = 10,
                pageindex = Convert.ToInt32(hddPageIndex.Value);
            DONGHEP_BL oBL = new DONGHEP_BL();
            DataTable oDT = oBL.GetDonGhep(vDonViID, DONID, LOAIANID);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                var count_all = Convert.ToInt32(oDT.Rows.Count);
                if (dgList.CurrentPageIndex > (Convert.ToInt32(hddTotalPage.Value) - 1))
                {
                    dgList.CurrentPageIndex = 0;
                }
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            dgList.DataSource = oDT;
            dgList.DataBind();
        }
        //dgList_ItemDataBound
        public void SetCheckBox(decimal Donxuly)
        {
            string keyDonID = "THONGTIN.DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            string keyLoaiAnId = "THONGTIN.DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            DONID = Convert.ToDecimal(Session[keyDonID]);
            LOAIANID = Convert.ToDecimal(Session[keyLoaiAnId]);
            foreach (DataGridItem Item in dgList.Items)
            {
                decimal idDonchitiet = Convert.ToDecimal(Item.Cells[0].Text);
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                bool isheck = false;

                if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU))
                {

                    isheck = dt.ADS_DON_XULY.Count(s => s.DON_XULYID == DONID && s.ID == Donxuly && s.DON_CHITIETID== idDonchitiet) > 0 ? true : false;
                }
                else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH))
                {
                    isheck = dt.AHN_DON_XULY.Count(s => s.DON_XULYID == DONID && s.ID == Donxuly && s.DON_CHITIETID == idDonchitiet) > 0 ? true : false;
                }
                else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI))
                {
                    isheck = dt.AKT_DON_XULY.Count(s => s.DON_XULYID == DONID && s.ID == Donxuly && s.DON_CHITIETID == idDonchitiet) > 0 ? true : false;
                }
                else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG))
                {
                    isheck = dt.ALD_DON_XULY.Count(s => s.DON_XULYID == DONID && s.ID == Donxuly && s.DON_CHITIETID == idDonchitiet) > 0 ? true : false;
                }
                else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH))
                {
                    isheck = dt.AHC_DON_XULY.Count(s => s.DON_XULYID == DONID && s.ID == Donxuly && s.DON_CHITIETID == idDonchitiet) > 0 ? true : false;
                }
                else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN))
                {
                    isheck = dt.APS_DON_XULY.Count(s => s.DON_XULYID == DONID && s.ID == Donxuly && s.DON_CHITIETID == idDonchitiet) > 0 ? true : false;
                }
                chkChon.Checked = isheck;
                chkChon.Enabled = false;
                chkChon.CssClass = "opa";
            }
        }

        public string ListIdThemMoi()
        {
            string strlstId = "";

            foreach (DataGridItem item in dgList.Items)
            {
                decimal Don_chiTietId = Convert.ToDecimal(item.Cells[0].Text);
                CheckBox chkChon = (CheckBox)item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    strlstId += Don_chiTietId + ",";
                }
            }
            return ","+ strlstId;
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                
                
                
            }
        }
        //public void DeleteDonChiTiet(decimal DON_XULYID)
        //{
        //    string keyDonID = "THONGTIN.DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
        //    string keyLoaiAnId = "THONGTIN.DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
        //    DONID = Convert.ToDecimal(Session[keyDonID]);
        //    LOAIANID = Convert.ToDecimal(Session[keyLoaiAnId]);
        //    if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU))
        //    {
        //        var lstDonXuLy = dt.ADS_DON_XULY.Where(s => s.ID == DON_XULYID);
        //        dt.ADS_DON_XULY.RemoveRange(lstDonXuLy);
        //    }
        //    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH))
        //    {
        //        var lstDonXuLy = dt.AHN_DON_XULY.Where(s => s.ID == DON_XULYID);
        //        dt.AHN_DON_XULY.RemoveRange(lstDonXuLy);
        //    }
        //    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI))
        //    {
        //        var lstDonXuLy = dt.AKT_DON_XULY.Where(s => s.ID == DON_XULYID);
        //        dt.AKT_DON_XULY.RemoveRange(lstDonXuLy);
        //    }
        //    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG))
        //    {
        //        var lstDonXuLy = dt.ALD_DON_XULY.Where(s => s.ID == DON_XULYID);
        //        dt.ALD_DON_XULY.RemoveRange(lstDonXuLy);
        //    }
        //    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH))
        //    {
        //        var lstDonXuLy = dt.AHC_DON_XULY.Where(s => s.ID == DON_XULYID);
        //        dt.AHC_DON_XULY.RemoveRange(lstDonXuLy);
        //    }
        //    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN))
        //    {
        //        var lstDonXuLy = dt.APS_DON_XULY.Where(s => s.ID == DON_XULYID);
        //        dt.APS_DON_XULY.RemoveRange(lstDonXuLy);
        //    }
        //    dt.SaveChanges();
        //}

        public bool IsCheckBox()
        {
            bool Ischeck = false;

            foreach (DataGridItem item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    Ischeck = true;
                    break;
                }
            }    

            return Ischeck;
        }

        public void UpdateDonChiTiet(int DonXyLyID,string hddCurrID,string txtSothongbao, string txtNgaythongbao,string txtLyDo,string txtNgayGQ, string bienphap,decimal hddToaAn,string txtCDNN_TenCoQuan,string txtCDNN_NgayChuyen,string txtTradon_Ngay,string ddlLyTradon,string txtYCBS,string txtThoihanBSYC)
        {

            if (bienphap== ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon || bienphap == ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon)
            {
                string keyDonID = "THONGTIN.DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
                string keyLoaiAnId = "THONGTIN.DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
                DONID = Convert.ToDecimal(Session[keyDonID]);
                LOAIANID = Convert.ToDecimal(Session[keyLoaiAnId]);

                if (DonXyLyID > 0)
                {
                    if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU))
                    {
                        ADS_DON_XULY obj = dt.ADS_DON_XULY.FirstOrDefault(s=>s.ID== DonXyLyID);
                        obj.SOTHONGBAO = txtSothongbao;
                        obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.LYDO = txtLyDo.Trim();
                        obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.DON_XULYID = DONID;
                        obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                        switch (bienphap)
                        {
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                obj.CDTN_TOAANID = hddToaAn;
                                //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_TENCQ = "";
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.YCBS_NOIDUNG = txtYCBS;
                                obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            default://Thụ lý
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";

                                //Cập nhật án phí
                                #region Thiều
                                //if (chkNopAnPhi.Checked == false)
                                //{
                                //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                //    if (rFileID > 0) obj.FILEID = rFileID;
                                //}
                                #endregion

                                break;
                        }
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }
                    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH))
                    {
                        AHN_DON_XULY obj = dt.AHN_DON_XULY.FirstOrDefault(s => s.ID == DonXyLyID);
                        //obj.DON_CHITIETID = Don_chiTietId;
                        obj.SOTHONGBAO = txtSothongbao;
                        obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.LYDO = txtLyDo.Trim();
                        obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.DON_XULYID = DONID;
                        obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                        switch (bienphap)
                        {
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                obj.CDTN_TOAANID = hddToaAn;
                                //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_TENCQ = "";
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.YCBS_NOIDUNG = txtYCBS;
                                obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            default://Thụ lý
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";

                                //Cập nhật án phí
                                #region Thiều
                                //if (chkNopAnPhi.Checked == false)
                                //{
                                //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                //    if (rFileID > 0) obj.FILEID = rFileID;
                                //}
                                #endregion

                                break;
                        }
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }
                    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI))
                    {
                        AKT_DON_XULY obj = dt.AKT_DON_XULY.FirstOrDefault(s => s.ID == DonXyLyID);
                        //obj.DON_CHITIETID = Don_chiTietId;
                        obj.SOTHONGBAO = txtSothongbao;
                        obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.LYDO = txtLyDo.Trim();
                        obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.DON_XULYID = DONID;
                        obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                        switch (bienphap)
                        {
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                obj.CDTN_TOAANID = hddToaAn;
                                //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_TENCQ = "";
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.YCBS_NOIDUNG = txtYCBS;
                                obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            default://Thụ lý
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";

                                //Cập nhật án phí
                                #region Thiều
                                //if (chkNopAnPhi.Checked == false)
                                //{
                                //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                //    if (rFileID > 0) obj.FILEID = rFileID;
                                //}
                                #endregion

                                break;
                        }
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }
                    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG))
                    {
                        ALD_DON_XULY obj = dt.ALD_DON_XULY.FirstOrDefault(s => s.ID == DonXyLyID);
                        //obj.DON_CHITIETID = Don_chiTietId;
                        obj.SOTHONGBAO = txtSothongbao;
                        obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.LYDO = txtLyDo.Trim();
                        obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.DON_XULYID = DONID;
                        obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                        switch (bienphap)
                        {
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                obj.CDTN_TOAANID = hddToaAn;
                                //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_TENCQ = "";
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.YCBS_NOIDUNG = txtYCBS;
                                obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            default://Thụ lý
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";

                                //Cập nhật án phí
                                #region Thiều
                                //if (chkNopAnPhi.Checked == false)
                                //{
                                //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                //    if (rFileID > 0) obj.FILEID = rFileID;
                                //}
                                #endregion

                                break;
                        }
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }
                    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH))
                    {
                        AHC_DON_XULY obj = dt.AHC_DON_XULY.FirstOrDefault(s => s.ID == DonXyLyID);
                        //obj.DON_CHITIETID = Don_chiTietId;
                        obj.SOTHONGBAO = txtSothongbao;
                        obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.LYDO = txtLyDo.Trim();
                        obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.DON_XULYID = DONID;
                        obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                        switch (bienphap)
                        {
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                obj.CDTN_TOAANID = hddToaAn;
                                //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_TENCQ = "";
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.YCBS_NOIDUNG = txtYCBS;
                                obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            default://Thụ lý
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";

                                //Cập nhật án phí
                                #region Thiều
                                //if (chkNopAnPhi.Checked == false)
                                //{
                                //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                //    if (rFileID > 0) obj.FILEID = rFileID;
                                //}
                                #endregion

                                break;
                        }
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }
                    else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN))
                    {
                        APS_DON_XULY obj = dt.APS_DON_XULY.FirstOrDefault(s => s.ID == DonXyLyID);
                        //obj.DON_CHITIETID = Don_chiTietId;
                        obj.SOTHONGBAO = txtSothongbao;
                        //obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.LYDO = txtLyDo.Trim();
                        obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        obj.DON_XULYID = DONID;
                        obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                        switch (bienphap)
                        {
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                obj.CDTN_TOAANID = hddToaAn;
                                //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_TENCQ = "";
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.TRADON_CANCUID = 0;
                                obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion
                                break;
                            case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";
                                //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.YCBS_NOIDUNG = txtYCBS;
                                obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                #region Thiều
                                //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                //if (rFileID > 0) obj.FILEID = rFileID;
                                #endregion

                                break;
                            default://Thụ lý
                                obj.TRADON_CANCUID = 0;
                                obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                obj.CDTN_TOAANID = 0;
                                obj.CDNN_TENCQ = "";

                                //Cập nhật án phí
                                #region Thiều
                                //if (chkNopAnPhi.Checked == false)
                                //{
                                //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                //    if (rFileID > 0) obj.FILEID = rFileID;
                                //}
                                #endregion

                                break;
                        }
                        obj.NGAYSUA = DateTime.Now;
                        obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        dt.SaveChanges();
                    }
                }
                else
                {
                    //thêm
                    foreach (DataGridItem item in dgList.Items)
                    {
                        CheckBox chkChon = (CheckBox)item.FindControl("chkChon");
                        if (chkChon.Checked)
                        {

                            decimal Don_chiTietId = Convert.ToDecimal(item.Cells[0].Text);

                            if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_DANSU))
                            {
                                ADS_DON_XULY obj = new ADS_DON_XULY();
                                obj.DON_CHITIETID = Don_chiTietId;
                                obj.SOTHONGBAO = txtSothongbao;
                                obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.LYDO = txtLyDo.Trim();
                                obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.DON_XULYID = DONID;
                                obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                                switch (bienphap)
                                {
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                        obj.CDTN_TOAANID = hddToaAn;
                                        //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_TENCQ = "";
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                        obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                        // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.YCBS_NOIDUNG = txtYCBS;
                                        obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    default://Thụ lý
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";

                                        //Cập nhật án phí
                                        #region Thiều
                                        //if (chkNopAnPhi.Checked == false)
                                        //{
                                        //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                        //    if (rFileID > 0) obj.FILEID = rFileID;
                                        //}
                                        #endregion

                                        break;
                                }
                                obj.NGAYTAO = DateTime.Now;
                                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                //update 14082025
                                if (obj.TOA_GIAIQUYET_ID == null) obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                dt.ADS_DON_XULY.Add(obj);
                                dt.SaveChanges();
                            }
                            else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH))
                            {
                                AHN_DON_XULY obj = new AHN_DON_XULY();
                                obj.DON_CHITIETID = Don_chiTietId;
                                obj.SOTHONGBAO = txtSothongbao;
                                obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.LYDO = txtLyDo.Trim();
                                obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.DON_XULYID = DONID;
                                obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                                switch (bienphap)
                                {
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                        obj.CDTN_TOAANID = hddToaAn;
                                        //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_TENCQ = "";
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                        obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                        // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.YCBS_NOIDUNG = txtYCBS;
                                        obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    default://Thụ lý
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";

                                        //Cập nhật án phí
                                        #region Thiều
                                        //if (chkNopAnPhi.Checked == false)
                                        //{
                                        //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                        //    if (rFileID > 0) obj.FILEID = rFileID;
                                        //}
                                        #endregion

                                        break;
                                }
                                obj.NGAYTAO = DateTime.Now;
                                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                
                                if (obj.TOA_GIAIQUYET_ID == null)
                                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                
                                dt.AHN_DON_XULY.Add(obj);
                                dt.SaveChanges();
                            }
                            else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI))
                            {
                                AKT_DON_XULY obj = new AKT_DON_XULY();
                                obj.DON_CHITIETID = Don_chiTietId;
                                obj.SOTHONGBAO = txtSothongbao;
                                obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.LYDO = txtLyDo.Trim();
                                obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.DON_XULYID = DONID;
                                obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                                switch (bienphap)
                                {
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                        obj.CDTN_TOAANID = hddToaAn;
                                        //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_TENCQ = "";
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                        obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                        // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.YCBS_NOIDUNG = txtYCBS;
                                        obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    default://Thụ lý
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";

                                        //Cập nhật án phí
                                        #region Thiều
                                        //if (chkNopAnPhi.Checked == false)
                                        //{
                                        //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                        //    if (rFileID > 0) obj.FILEID = rFileID;
                                        //}
                                        #endregion

                                        break;
                                }
                                obj.NGAYTAO = DateTime.Now;
                                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                // insert toa_gq_id
                                if (obj.TOA_GIAIQUYET_ID == null)
                                {
                                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                }
                                dt.AKT_DON_XULY.Add(obj);
                                dt.SaveChanges();
                            }
                            else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG))
                            {
                                ALD_DON_XULY obj = new ALD_DON_XULY();
                                obj.DON_CHITIETID = Don_chiTietId;
                                obj.SOTHONGBAO = txtSothongbao;
                                obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.LYDO = txtLyDo.Trim();
                                obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.DON_XULYID = DONID;
                                obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                                switch (bienphap)
                                {
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                        obj.CDTN_TOAANID = hddToaAn;
                                        //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_TENCQ = "";
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                        obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                        // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.YCBS_NOIDUNG = txtYCBS;
                                        obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    default://Thụ lý
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";

                                        //Cập nhật án phí
                                        #region Thiều
                                        //if (chkNopAnPhi.Checked == false)
                                        //{
                                        //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                        //    if (rFileID > 0) obj.FILEID = rFileID;
                                        //}
                                        #endregion

                                        break;
                                }
                                obj.NGAYTAO = DateTime.Now;
                                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                dt.ALD_DON_XULY.Add(obj);
                                dt.SaveChanges();
                            }
                            else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH))
                            {
                                AHC_DON_XULY obj = new AHC_DON_XULY();
                                obj.DON_CHITIETID = Don_chiTietId;
                                obj.SOTHONGBAO = txtSothongbao;
                                obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.LYDO = txtLyDo.Trim();
                                obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.DON_XULYID = DONID;
                                obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                                // update 060825
                                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                switch (bienphap)
                                {
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                        obj.CDTN_TOAANID = hddToaAn;
                                        //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_TENCQ = "";
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                        obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                        // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.YCBS_NOIDUNG = txtYCBS;
                                        obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    default://Thụ lý
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";

                                        //Cập nhật án phí
                                        #region Thiều
                                        //if (chkNopAnPhi.Checked == false)
                                        //{
                                        //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                        //    if (rFileID > 0) obj.FILEID = rFileID;
                                        //}
                                        #endregion

                                        break;
                                }
                                obj.NGAYTAO = DateTime.Now;
                                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                dt.AHC_DON_XULY.Add(obj);
                                dt.SaveChanges();
                            }
                            else if (LOAIANID == int.Parse(ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN))
                            {
                                APS_DON_XULY obj = new APS_DON_XULY();
                                obj.DON_CHITIETID = Don_chiTietId;
                                obj.SOTHONGBAO = txtSothongbao;
                                //obj.NGAYTHONGBAO = (String.IsNullOrEmpty(txtNgaythongbao.Trim())) ? (DateTime?)null : DateTime.Parse(txtNgaythongbao.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.LYDO = txtLyDo.Trim();
                                obj.NGAYGQ_YC = (String.IsNullOrEmpty(txtNgayGQ.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayGQ.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                                obj.DON_XULYID = DONID;
                                obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                obj.LOAIGIAIQUYET = Convert.ToDecimal(bienphap);
                                switch (bienphap)
                                {
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonTrongNganh:
                                        obj.CDTN_TOAANID = hddToaAn;
                                        //obj.CDTN_NGAYNHAN = (String.IsNullOrEmpty(txtCDTN_NgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtCDTN_NgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.CDTN_NGAYCHUYEN = DateTime.Now;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_TENCQ = "";
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "25-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_ChuyenDonNgoaiNganh:
                                        obj.CDNN_TENCQ = txtCDNN_TenCoQuan.Trim();
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDNN_NGAYCHUYEN = (String.IsNullOrEmpty(txtCDNN_NgayChuyen.Trim())) ? DateTime.MinValue : DateTime.Parse(txtCDNN_NgayChuyen.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon:
                                        // obj.TRADON_CANCUID = Convert.ToDecimal(txtToiDanh.Text.Trim());
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        obj.TRADON_NGAYTRA = (String.IsNullOrEmpty(txtTradon_Ngay.Trim())) ? DateTime.MinValue : DateTime.Parse(txtTradon_Ngay.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.TRADON_LYDOID = Convert.ToDecimal(ddlLyTradon);
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "27-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion
                                        break;
                                    case ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon:
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";
                                        //obj.YCBS_NGAYYEUCAU = (String.IsNullOrEmpty(txtNgayYCBS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayYCBS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                        obj.YCBS_NOIDUNG = txtYCBS;
                                        obj.YCBS_THOIHAN = (String.IsNullOrEmpty(txtThoihanBSYC.Trim())) ? 0 : Convert.ToDecimal(txtThoihanBSYC.Trim());
                                        #region Thiều
                                        //rFileID = UploadFileID(oDon, FileID, "26-DS", obj.SOTHONGBAO);
                                        //if (rFileID > 0) obj.FILEID = rFileID;
                                        #endregion

                                        break;
                                    default://Thụ lý
                                        obj.TRADON_CANCUID = 0;
                                        obj.CDTN_NGAYNHAN = DateTime.MinValue;
                                        obj.CDTN_TOAANID = 0;
                                        obj.CDNN_TENCQ = "";

                                        //Cập nhật án phí
                                        #region Thiều
                                        //if (chkNopAnPhi.Checked == false)
                                        //{
                                        //    rFileID = UploadFileID(oDon, FileID, "29-DS", obj.SOTHONGBAO);
                                        //    if (rFileID > 0) obj.FILEID = rFileID;
                                        //}
                                        #endregion

                                        break;
                                }
                                obj.NGAYTAO = DateTime.Now;
                                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                                dt.APS_DON_XULY.Add(obj);
                                dt.SaveChanges();
                            }
                        }
                    }
                }

                
            }

            

        }

        //protected void chkChon_CheckedChanged(object sender, EventArgs e)
        //{
        //    CheckBox checkboxCurrent = (CheckBox)sender;
        //    foreach (DataGridItem item in dgList.Items)
        //    {

        //        CheckBox checkBox = (CheckBox)item.FindControl("chkChon");
        //        if (checkboxCurrent != checkBox)
        //        {
        //            checkBox.Checked = false;
        //        }
        //        else
        //        {
        //            IdDonGhep = Convert.ToDecimal(item.Cells[0].Text);
        //        }
        //    }
        //}
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            //decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            ////string keyDonID = "DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            //string keyLoaiAnId = "THONGTIN.DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            //LOAIANID = Convert.ToDecimal(Session[keyLoaiAnId]);
            //switch (e.CommandName)
            //{
            //    case "Sua":
            //        Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_edit_DONGHEP(" + LOAIANID + "," + ND_id + ")");
            //        break;
            //    case "Xoa":
            //        DON_CHITIET obj = dt.DON_CHITIET.FirstOrDefault(s => s.ID == ND_id);

            //        List<DON_CHITIET_DUONGSU> lstDonChiTietDuongSu = dt.DON_CHITIET_DUONGSU.Where(s => s.DONID == obj.ID).ToList();

            //        dt.DON_CHITIET.Remove(obj);
            //        dt.DON_CHITIET_DUONGSU.RemoveRange(lstDonChiTietDuongSu);
            //        dt.SaveChanges();
            //        LtrThongBao.Text = "Xóa thành công";
            //        lbtimkiem_Click(null, null);
            //        break;
            //}

        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbThemMoiDon_Click(object sender, EventArgs e)
        {
            ////string keyDonID = "DONGHEP.DONID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            //string keyLoaiAnId = "DONGHEP.LOAIANID" + Session[ENUM_SESSION.SESSION_USERID].ToString();
            //LOAIANID = Convert.ToDecimal(Session[keyLoaiAnId]);
            //Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_edit_DONGHEP(" + LOAIANID + ")");
        }
        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }

        #endregion
    }
}