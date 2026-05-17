using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
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
using BL.GSTP.THA;
using BL.GSTP.Quantri;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.THA.UyThacTHA
{
    public partial class UyThacTHA : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        THA_UYTHAC_DETAIL obj = new THA_UYTHAC_DETAIL();
        private const decimal ROOT = 0;
        Decimal CurrUserID = 0,  VuAnID = 0,BiAnID = 0;
        public string NgaySoSanh;

        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");

                if (!IsPostBack)
                {
                    if (BiAnID > 0)
                    {
                        load_ddlNguoiki();
                        pn.Visible = true;
                        LoadDrop();
                        LoadGrid();
                        CheckQuyen();
                        txtNgayUyThac.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
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
        //----------------------------------

        void CheckQuyen()
        {
            Boolean IsOk = true;
            try
            {
                THA_UYTHAC_QUYETDINH obj = dt.THA_UYTHAC_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_UYTHAC_QUYETDINH>();
                if (obj == null)
                {
                    lttMsg.Text = "Bị án chưa có quyết định ủy thác thi thành án. Bạn hãy kiểm tra lại!";
                    cmdUpdate.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có quyết định ủy thác thi thành án. Bạn hãy kiểm tra lại!";
                cmdUpdate.Visible = false;
                IsOk = false;
            }
            ////-----------------------------
            //if (!IsOk)
            //{
            //    try
            //    {
            //        THA_BIAN_QUYETDINH objQD = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
            //        if (objQD != null)
            //            NgaySoSanh = ((DateTime)objQD.NGAYTHIHANH).ToString("dd/MM/yyyy", cul);
            //        else
            //        {
            //            lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
            //            cmdUpdate.Visible = false;
            //            IsOk = false;
            //        }
            //    }
            //    catch (Exception ex)
            //    {
            //        lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
            //        cmdUpdate.Visible = false;
            //        IsOk = false;
            //    }
            //}
        }

        void LoadDrop()
        {
            LoadDrop_QDUyThacTHA();
            LoadDropNguoiNhan();
           // LoadDropByGroupName(dropLyDo, ENUM_DANHMUC.UYTHACTHA_LyDo, true);
        }
        //-----------------
        void LoadDrop_QDUyThacTHA()
        {
            dropQuyetDinhUyThacTHA.Items.Clear();
            dropQuyetDinhUyThacTHA.Items.Add(new ListItem("--- Chọn ---", "0"));
            THA_UYTHAC_QUYETDINH_BL oT = new THA_UYTHAC_QUYETDINH_BL();
            DataTable tbl = oT.GetAllByBiAnID(BiAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ListItem item = null;               
                foreach(DataRow row in tbl.Rows)
                {
                    item = new ListItem();
                    item.Value = row["ID"] + "";
                    item.Text = row["MAQD"].ToString() + " - "+ row["TENQD"].ToString();
                    dropQuyetDinhUyThacTHA.Items.Add(item);
                }
            }
        }
        protected void dropQuyetDinhUyThacTHA_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropQuyetDinhUyThacTHA.SelectedValue != "0")
            {
                decimal QuyetDinhID = Convert.ToDecimal(dropQuyetDinhUyThacTHA.SelectedValue);
                LoadZoneQuyetDinhTHAByID(QuyetDinhID);
                THA_UYTHAC_DETAIL obj = dt.THA_UYTHAC_DETAIL.Where(x => x.QD_UYTHACTHA_ID == QuyetDinhID && x.BIANID == BiAnID).FirstOrDefault();
                if (obj != null)
                {
                    if (obj.TRANGTHAI == 1)
                    {
                        cmdUpdate.Visible = false;
                    }
                    else
                    {
                        cmdUpdate.Visible = true;
                    }
                    LoadUyThacDetail(obj);
                }
                else
                {
                    rdTHUyThac.SelectedValue = "0";
                    hddLyDoKhacID.Value = null;
                    hddLoaiUyThac.Value = "0";
                    pnLyDoKhac.Visible = false;
                    txtLydoKhac.Text = null;
                    lblFileName.Text = string.Empty;
                }
            }
            else
            {
                txtToaAnUyThac.Text = txtUy_thac.Text = "";
                txtQD_SoQD.Text = txtQD_NgayQD.Text=  "";
            }
        }
        void LoadZoneQuyetDinhTHAByID(decimal QuyetDinhID)
        {
            THA_UYTHAC_QUYETDINH obj = dt.THA_UYTHAC_QUYETDINH.Where(x => x.ID == QuyetDinhID).SingleOrDefault();
            if (obj != null)
            {
                Decimal toaanID = (Decimal)obj.TOAANNHANUYTHACID;
                txtToaAnUyThac.Text = dt.DM_TOAAN.Where(x => x.ID == toaanID).SingleOrDefault().TEN;

                toaanID = (Decimal)obj.TOAANUYTHACID;
                txtUy_thac.Text = dt.DM_TOAAN.Where(x => x.ID == toaanID).SingleOrDefault().TEN;
                DropNguoiKi.SelectedValue = obj.NGUOIKY;
                txtQD_NgayQD.Text = String.IsNullOrEmpty(obj.NGAYQD + "") ? "" : ((DateTime)obj.NGAYQD).ToString("dd/MM/yyyy", cul);
                txtQD_SoQD.Text = obj.SOQD + "";
                txtQD_NgayQD.Enabled = txtQD_SoQD.Enabled = txtToaAnUyThac.Enabled = txtUy_thac.Enabled = false;
            }
        }
        //---------------------
        void LoadDropNguoiNhan()
        {
            DM_CANBO_BL obj = new DM_CANBO_BL();
            Decimal donvi = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //  DataTable oCBDT = oDMCBBL.GetAllChanhAn_PhoCA(donvi);
            DataTable tbl = obj.DM_CANBO_GETBYDONVI(donvi);
            dropNguoiNhap.DataSource = tbl;
            dropNguoiNhap.DataTextField = "HOTEN";
            dropNguoiNhap.DataValueField = "ID";
            dropNguoiNhap.DataBind();
            dropNguoiNhap.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        public void load_ddlNguoiki()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            Decimal donvi = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable oCBDT = oDMCBBL.GetAllChanhAn_PhoCA(donvi);

            DropNguoiKi.DataSource = oCBDT;
            DropNguoiKi.DataTextField = "HOTEN";
            DropNguoiKi.DataValueField = "ID";
            DropNguoiKi.DataBind();
            DropNguoiKi.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("---Chọn---", "0"));
            foreach (DataRow row in tbl.Rows)
            {
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
            }
        }
       
        //----------------------------------
        //protected void rdTruongHopUT_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    pnLyDo.Visible = pnKhac.Visible = false;
        //    if (rdTruongHopUT.SelectedValue == "0")
        //    {
        //        pnLyDo.Visible = true;
        //        dropLyDo.SelectedValue = "0";
        //        hddLoaiUyThac.Value = "0";
        //    }
        //    else
        //    { pnLyDo.Visible = false; hddLoaiUyThac.Value = "1"; }
        //}
        protected void rdTHUyThac_SelectedIndexChanged(object sender, EventArgs e)
        {
           // pnLyDo.Visible = pnKhac.Visible = false;
            if (rdTHUyThac.SelectedValue == "0")
            {
                pnLyDoKhac.Visible = false;
                //txtLydoKhac.Visible = false;    
            }
            else
            {
                pnLyDoKhac.Visible = true;
                //txtLydoKhac.Visible = true; 
            }
        }   
        private void loadEdit(decimal ID)
        {
            THA_UYTHAC_DETAIL obj = dt.THA_UYTHAC_DETAIL.Where(x => x.ID == ID).FirstOrDefault();
            if (obj != null)
                LoadUyThacDetail(obj);
        }
        void LoadUyThacDetail(THA_UYTHAC_DETAIL obj)
        {
            HddID.Value = ID.ToString();
            try
            {
                dropQuyetDinhUyThacTHA.SelectedValue = obj.QD_UYTHACTHA_ID + "";
                LoadZoneQuyetDinhTHAByID(Convert.ToDecimal(obj.QD_UYTHACTHA_ID));
            }
            catch (Exception ex) { }

            //------------------------------
            //rdTruongHopUT.SelectedValue = (string.IsNullOrEmpty(obj.LOAIUYTHAC + "")) ? "0" : obj.LOAIUYTHAC.ToString();
            //if (rdTruongHopUT.SelectedValue == "0")
            //{
            //    pnLyDo.Visible = true;
            //    dropLyDo.SelectedValue = "0";
            //    hddLoaiUyThac.Value = "0";
            //}
            //else
            //{
            //    pnLyDo.Visible = false;
            //    hddLoaiUyThac.Value = "1";
            //}
            ////------------------------------
            //dropLyDo.SelectedValue = (String.IsNullOrEmpty(obj.LYDOID + "")) ? "0" : obj.LYDOID.ToString();

            rdTHUyThac.SelectedValue = (string.IsNullOrEmpty(obj.LOAIUYTHAC + "")) ? "0" : obj.LOAIUYTHAC.ToString();
            if (rdTHUyThac.SelectedValue == "0")
            {
                pnLyDoKhac.Visible = false;
                hddLyDoKhacID.Value = null;
                txtLydoKhac.Text = null;
            }
            else
            {
                pnLyDoKhac.Visible = true;
                //hddLyDoKhacID.Value = obj.LYDOID.ToString();
                txtLydoKhac.Text = obj.UYTHACKHAC;
            }
            //------------------------------     
            txtNgayUyThac.Text = String.IsNullOrEmpty(obj.NGAYUYTHAC + "") ? "" : ((DateTime)obj.NGAYUYTHAC).ToString("dd/MM/yyyy", cul);
            txtNgayNhan.Text = String.IsNullOrEmpty(obj.NGAYNHANUYTHAC + "") ? "" : ((DateTime)obj.NGAYNHANUYTHAC).ToString("dd/MM/yyyy", cul);

            txtGhichu.Text = obj.GHICHU + "";

            try
            {
                dropNguoiNhap.SelectedValue = (String.IsNullOrEmpty(obj.NGUOINHAP + "")) ? "0" : obj.NGUOINHAP.ToString();
            }
            catch (Exception ex) { }

            // Hien thi ten file neu da co tep dinh kem
            try
            {
                if (obj.QT_FILE_ID != null)
                {
                    QT_FILE qtFile = DataExtensions.FindById<QT_FILE>(obj.QT_FILE_ID.Value);
                    lblFileName.Text = qtFile != null ? qtFile.FILE_NAME : string.Empty;
                }
                else
                {
                    lblFileName.Text = string.Empty;
                }
            }
            catch { lblFileName.Text = string.Empty; }
        }
        //-----------------------------------------
        private void LoadGrid()
        {
            lbthongbao.Text = "";
            decimal BiAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_UYTHAC_DETAIL_BL objBL = new THA_UYTHAC_DETAIL_BL();
            DataTable tbl = objBL.GetAllByBiAnID(BiAnID);
            if (tbl != null)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                checkTrangThaiUyThac();
                pndata.Visible = true;
            }
            else
                pndata.Visible = false;
        }
        public void checkTrangThaiUyThac()
        {
            foreach (RepeaterItem Item in rpt.Items)
            {
                //LinkButton lblSua = (LinkButton)Item.FindControl("lbtSua");
                //LinkButton lbtXoa = (LinkButton)Item.FindControl("lbtXoa");
                //HiddenField trangthai = (HiddenField)Item.FindControl("TRANGTHAI");

                //if (trangthai.Value.Equals("0"))
                //{
                //    lblSua.Visible = true;
                //    lbtXoa.Visible = true;

                //}
                //else
                //{
                //    lblSua.Visible = false;
                //    lbtXoa.Visible = false;
                //}
            }
            
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadEdit(ID);
                    HddID.Value = e.CommandArgument.ToString();
                    hddFilePath.Value = "";
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(ID);
                    break;
                case "Download":
                    try
                    {
                        THA_UYTHAC_DETAIL uyThacDetail = dt.THA_UYTHAC_DETAIL.Where(x => x.ID == ID).FirstOrDefault();
                        if (uyThacDetail.QT_FILE_ID != null)
                        {
                            QT_FILE qtFileGet = DataExtensions.FindById<QT_FILE>(uyThacDetail.QT_FILE_ID.Value);
                            var cacheKey = Guid.NewGuid().ToString("N");
                            QT_FILE_BL fileH = new QT_FILE_BL();
                            byte[] file = fileH.GetNoiDungFile_Minio_THA(qtFileGet, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_THA), "BANANSOTHAM");
                            if (file == null)
                            {
                                lbthongbao.Text = "Không tìm thấy file đính kèm!";
                                return;
                            }
                            Context.Cache.Insert(key: cacheKey, value: file, dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + qtFileGet.FILE_NAME + "&Extension=" + qtFileGet.FILE_TYPE + "';", true);
                        }
                    }
                    catch (Exception ex)
                    {
                        lbthongbao.Text = ex.Message;
                        Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", ex.Message);
                    }
                    break;
            }
        }
        public void xoa(decimal ID)
        {
            THA_UYTHAC_DETAIL oGA = dt.THA_UYTHAC_DETAIL.Where(x => x.ID == ID).FirstOrDefault();
            if (oGA != null)
            {

                // xoa file MinIO
                if (oGA.QT_FILE_ID != null)
                {
                    QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oGA.QT_FILE_ID.Value);
                    if (qtFileDelete != null)
                    {
                        qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_THA + ".";
                        QT_FILE_BL fileH = new QT_FILE_BL();
                        fileH.DeleteFileLogic(qtFileDelete);
                    }
                }
                dt.THA_UYTHAC_DETAIL.Remove(oGA);
                dt.SaveChanges();
                LoadGrid();
                ResetControls();
                //dgList.CurrentPageIndex = 0;
                lbthongbao.Text = "Xóa thành công!";
            }
        }

        //-----------------------------------------
        protected void cmdResert_Click(object sender, EventArgs e)
        {
            ResetControls();
        }
        public void ResetControls()
        {
            dropQuyetDinhUyThacTHA.SelectedIndex = 0;
            txtToaAnUyThac.Text = txtUy_thac.Text = "";
            txtQD_SoQD.Text = txtQD_NgayQD.Text = "";

            rdTHUyThac.SelectedValue = "0";
            hddLyDoKhacID.Value = null;
            hddLoaiUyThac.Value = "0";
            pnLyDoKhac.Visible = false;
            txtLydoKhac.Text = null;

            txtNgayNhan.Text = txtNgayUyThac.Text = "";
            txtGhichu.Text = "";
            DropNguoiKi.SelectedValue = "0";
            HddID.Value = "0";
            lbthongbao.Text = hddFilePath.Value = ""; ;
            lblFileName.Text = string.Empty;
            // dropLyDo.SelectedValue = dropNguoiNhap.SelectedValue = "0";
            // pnLyDo.Visible = true;
            // dropLyDo.SelectedValue = "0";
            // rdTruongHopUT.SelectedValue = "0";
        }

        //--------------------------------------
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                Decimal QuyetDinhTHA_ID = Convert.ToDecimal(dropQuyetDinhUyThacTHA.SelectedValue);
                THA_UYTHAC_DETAIL obj = dt.THA_UYTHAC_DETAIL.Where(x => x.BIANID == BiAnID && x.QD_UYTHACTHA_ID== QuyetDinhTHA_ID).FirstOrDefault();
                if (obj != null)
                {
                    if (obj.TRANGTHAI == 3)
                    {
                        lbthongbao.Text = "Không thể sửa do ủy thác đã bị từ chối!";
                        return;
                    }
                    LayDuLieuUpdate(obj);
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA =Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] );
                }
                else
                {
                    obj = new THA_UYTHAC_DETAIL();
                    LayDuLieuUpdate(obj);
                    obj.NGAYTAO = DateTime.Now;
                    obj.NGUOITAO = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    obj.TRANGTHAI = 0; //0 la chua nhận ủy thác THA
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.THA_UYTHAC_DETAIL.Add(obj);
                }
                dt.SaveChanges();
                LoadGrid();
                ResetControls();
                lbthongbao.Text = "Lưu thành công!";
            }
            catch (Exception exc)
            {
                lbthongbao.Text = exc.Message;
            }
        }
      
        public void LayDuLieuUpdate(THA_UYTHAC_DETAIL obj)
        {
            obj.BIANID = BiAnID;


            obj.QD_UYTHACTHA_ID = Convert.ToDecimal(dropQuyetDinhUyThacTHA.SelectedValue);

            //obj.LOAIUYTHAC = Convert.ToDecimal(rdTruongHopUT.SelectedValue);
            //if (obj.LOAIUYTHAC == 0)
            //    obj.LYDOID = Convert.ToDecimal(dropLyDo.SelectedValue);
            //else
            //    obj.LYDOID = 0;

            if (Convert.ToDecimal(rdTHUyThac.SelectedValue) == 0)
            {
                obj.LOAIUYTHAC = 0;
                obj.LYDOID = 970;//970 là LYDOID của "Ủy thác không có thẩm quyền"
            }
            else
            {
                obj.LOAIUYTHAC = 1;
                obj.UYTHACKHAC = txtLydoKhac.Text.Trim();
            }

            //------------------  
            obj.NGAYUYTHAC = (String.IsNullOrEmpty(txtNgayUyThac.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayUyThac.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYNHANUYTHAC = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

            //-------------------
            obj.NGUOINHAP = String.IsNullOrEmpty(dropNguoiNhap.SelectedValue) ? 0 : Convert.ToDecimal(dropNguoiNhap.SelectedValue);
            obj.GHICHU = txtGhichu.Text.Trim();

            try
            {
                if (hddFilePath.Value != "")
                {
                    string strFilePath = hddFilePath.Value.Replace("/", "\\");
                    QT_FILE_BL fileHelper = new QT_FILE_BL();
                    QT_FILE qtFile = fileHelper.InsertFile_Minio_Banan(strFilePath, Convert.ToInt32(ENUM_LOAIVUVIEC_NUMBER.AN_THA), "BANANSOTHAM");
                    if (qtFile == null)
                    {
                        lbthongbao.Text = "Lỗi khi lưu file!";
                        return;
                    }

                    // Cập nhật QT_FILE_ID trực tiếp trên entity được track
                    obj.QT_FILE_ID = qtFile.ID;
                }
            }
            catch { }
        }

        protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {
            try
            {
                if (AsyncFileUpLoad.HasFile)
                {
                    string strFileName = AsyncFileUpLoad.FileName;
                    string path = Server.MapPath("~/TempUpload/") + strFileName;
                    AsyncFileUpLoad.SaveAs(path);
                    path = path.Replace("\\", "/");
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
                    lblFileName.Text = strFileName;
                }
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lbtSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");
                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                HiddenField trangthai = (HiddenField)e.Item.FindControl("TRANGTHAI");

                lblDownload.Visible = !string.IsNullOrEmpty(rowView["FILE_ID"] + "");

                if (trangthai.Value.Equals("0"))
                {
                    lblSua.Visible = true;
                    lbtXoa.Visible = true;

                }
                else
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }

                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                }
            }
        }
    }
}