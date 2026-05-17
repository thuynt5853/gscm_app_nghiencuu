
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using DAL.GSTP;
using BL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.THA;
using Module.Common;
using BL.GSTP.Quantri;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.THA.CongVanTHA
{
    public partial class ThuLy : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrUserID = 0, VuAnID = 0, BiAnID = 0;
        public string NgaySoSanh;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                    hddBiAnID.Value = BiAnID.ToString();

                    if (BiAnID > 0)
                    {
                        pn.Visible = true;
                        THA_BIAN objBA = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
                        if (objBA != null)
                        {
                            VuAnID = (decimal)objBA.VUANID;
                            hddVuAnID.Value = VuAnID.ToString();
                        }
                        CheckQuyen();
                        //---------------------------
                        LoadDrop();
                        LoadDsThuLy();
                    }
                    else
                    {
                        pn.Visible = false;
                        lbthongbao.Text = "Bạn cần chọn bị án để xử lý!";
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
                 NgaySoSanh = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                else
                {
                    lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                    cmdSave.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                cmdSave.Visible = false;
                IsOk = false;
            }
            //-----------------------------
            if (IsOk)
            {
                try
                {
                    THA_BIAN_QUYETDINH objQD = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                    if (objQD != null)
                        NgaySoSanh = ((DateTime)objQD.NGAYTHIHANH).ToString("dd/MM/yyyy", cul);
                    else
                    {
                        lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                        cmdSave.Visible = false;
                        IsOk = false;
                    }
                }
                catch (Exception ex)
                {
                    lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                    cmdSave.Visible = false;
                    IsOk = false;
                }
            }
        }
        void LoadDrop()
        {
            LoadDropByGroupName(dropDon_QuocTich, ENUM_DANHMUC.QUOCTICH, true);
            LoadDropByGroupName(dropYeuCau, ENUM_DANHMUC.THA_YEUCAUTHULY, true);
            dropLyDo.Items.Clear();
            dropLyDo.Items.Add(new ListItem("---Chọn---", "0"));

            LoadDropNguoiNhan();
        }
        void LoadDropNguoiNhan()
        {
            Decimal donvi = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.GetAllChanhAn_PhoCA(donvi);
            dropNguoiNhan.DataSource = oCBDT;
            dropNguoiNhan.DataTextField = "HOTEN";
            dropNguoiNhan.DataValueField = "ID";
            dropNguoiNhan.DataBind();
            dropNguoiNhan.Items.Insert(0, new ListItem("--Chọn--", "0"));
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
        //---------------------------

        protected void dropYeuCau_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDropLyDo();
        }
        void LoadDropLyDo()
        {
            Decimal yeucau_id = Convert.ToDecimal(dropYeuCau.SelectedValue);
            if (yeucau_id > 0)
            {
                //load drop ly do tuong ung
                dropLyDo.Items.Clear();
                DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
                DataTable tbl = oBL.DM_DATAITEM_GETBYPARENTID(yeucau_id);
                dropLyDo.Items.Add(new ListItem("---Chọn---", "0"));
                foreach (DataRow row in tbl.Rows)
                    dropLyDo.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
            }
        }

        protected void rdLoaiDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdLoaiDon.SelectedValue != "0")
            {
                //don 
                pnRowLoai.Visible = true;
                pnCongVanEdit.Visible = false;
                pnDon.Visible = true;
                lttGroup.Text = "Thông tin đơn: " + rdNguoiLamDon.SelectedItem.Text;
            }
            else
            {
                //cong van
                pnRowLoai.Visible = false;
                pnCongVanEdit.Visible = true;
                pnDon.Visible = false;
                lttGroup.Text = "Thông tin công văn";
            }
        }

        protected void rdNguoiLamDon_SelectedIndexChanged(object sender, EventArgs e)
        {
            lttGroup.Text = "Thông tin đơn: " + rdNguoiLamDon.SelectedItem.Text;
            if (rdNguoiLamDon.SelectedValue !="0")
            {
                // nguoi than
                pnDon_NguoiThan.Visible = true;
                pnDon_BiAn.Visible = false;
            }
            else
            {                
                //Bi an
                pnDon_NguoiThan.Visible = false;
                pnDon_BiAn.Visible = true;
            }
         }

        //------------------------
        void LoadThongTinThuLy()
        {
            lstMsgTop.Text = "";
             String datetemp = "";
            Decimal ThuLyId = (string.IsNullOrEmpty(hddThuLyID.Value)) ? 0 : Convert.ToDecimal(hddThuLyID.Value);
            hddThuLyID.Value = ThuLyId + "";
            THA_CVDON_THULY obj = dt.THA_CVDON_THULY.Where(x => x.ID == ThuLyId).Single<THA_CVDON_THULY>();
            if (obj != null)
            {
                rdLoaiDon.SelectedValue = obj.LOAIDON + "";
                rdNguoiLamDon.SelectedValue = obj.NGUOILAMDON + "";

                int loai_don = 0, nguoi_lam_don = 0;
                loai_don = Convert.ToInt16(obj.LOAIDON);
                nguoi_lam_don = Convert.ToInt16(obj.NGUOILAMDON);
                switch (loai_don)
                {
                    case 0:
                        //cong van
                        pnCongVanEdit.Visible = true;
                        pnDon.Visible = false;

                        txtSoCongVan.Text= obj.CV_SO +"";
                        datetemp = ((obj.CV_NGAY != null) && (((DateTime)obj.CV_NGAY) != DateTime.MinValue)) ? ((DateTime)obj.CV_NGAY).ToString("dd/MM/yyyy", cul) : "";
                        txtNgayCongVan.Text = datetemp; 

                        txtTenCoQuan.Text = obj.CV_TENCOQUAN;
                        txtDiaChi.Text = obj.CV_DIACHI;
                        txtNguoiKy.Text = obj.CV_NGUOIKY + "";
                        txtChucVu.Text = obj.CV_CHUCVU + "";
                        break;
                    case 1:
                        //don
                        pnRowLoai.Visible = true;
                        pnCongVanEdit.Visible = false;
                        pnDon.Visible = true;

                        rdNguoiLamDon.SelectedValue = nguoi_lam_don+"";
                        lttGroup.Text = "Thông tin đơn: " + rdNguoiLamDon.SelectedItem.Text;
                        txtDon_SoThuLy.Text = obj.SOTHULY + "";
                        datetemp = ((obj.NGAYTHULY != null) && (((DateTime)obj.NGAYTHULY) != DateTime.MinValue))? ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul) : "";
                        txtDon_NgayThuLy.Text = datetemp;
                        switch (nguoi_lam_don)
                        {
                            case 0:
                                //bi an 
                                pnDon_BiAn.Visible = true;
                                pnDon_NguoiThan.Visible = false;
                                datetemp = ((obj.DON_NGAY != null) && (((DateTime)obj.DON_NGAY) != DateTime.MinValue)) ? ((DateTime)obj.DON_NGAY).ToString("dd/MM/yyyy", cul) : "";
                                txtDon_NgayLamCongVan.Text = datetemp;
                                break;
                            case 1:
                                //nguoi than
                                pnDon_BiAn.Visible = false;
                                pnDon_NguoiThan.Visible = true;

                                txtDon_NguoiLamDon.Text =obj.DON_HOTEN ;
                                datetemp = ((obj.DON_NGAYSINH != null) && (((DateTime)obj.DON_NGAYSINH) != DateTime.MinValue)) ? ((DateTime)obj.DON_NGAYSINH).ToString("dd/MM/yyyy", cul) : "";
                                txtDon_NgaySinh.Text = datetemp;

                                txtDon_CMND.Text = obj.DON_CMND;
                                txtDon_QuanHeVoiBiAn.Text= obj.DON_QUANHE ;
                                txtDon_HoKhauTT.Text= obj.DON_HKTT ;
                                txtDon_TamTru.Text= obj.DON_TAMTRU ;
                                dropDon_QuocTich.SelectedValue = obj.DON_QUOCTICHID + "";
                                break;
                        }
                        break;
                }

                dropYeuCau.SelectedValue = obj.YEUCAUID.ToString();
                LoadDropLyDo();
                dropLyDo.SelectedValue= obj.LYDOID.ToString();

                txtYKien.Text = obj.YKIENPHUONGXA;

                datetemp =(( obj.NGAYNHAN != null) && (((DateTime)obj.NGAYNHAN) != DateTime.MinValue)) ? ((DateTime)obj.NGAYNHAN).ToString("dd/MM/yyyy", cul) : "";
                txtNgayNhan.Text = datetemp;

                dropNguoiNhan.SelectedValue = obj.NGUOINHANID+"";
            }
        }
        //------------------------
        protected void cmdSave_Click(object sender, EventArgs e)
        {
            string loai_thu_ly = "";
            Boolean IsUpdate = false;
            BiAnID = Convert.ToDecimal(hddBiAnID.Value);
            VuAnID = Convert.ToDecimal(hddVuAnID.Value);
            Decimal ThuLyId = (string.IsNullOrEmpty(hddThuLyID.Value)) ? 0 : Convert.ToDecimal(hddThuLyID.Value);

            THA_BIAN_QUYETDINH qdBian = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnID).FirstOrDefault();

            //Kiem tra xem da có THA_CVDON_KQGQ thi khong cho sua
            if (qdBian != null)
            {
                THA_CVDON_KQGQ obj = null;
                try
                {
                    obj = dt.THA_CVDON_KQGQ.Where(x => x.CVDONID == ThuLyId).Single<THA_CVDON_KQGQ>();
                }
                catch (Exception ex) { }
                //Kiem tra xem có Ket qua giai quyet thi khong duoc sua
                if (obj != null)
                {
                    lstMsgTop.Text = "Đã có 4.2 Kết quả giải quyết công văn/đơn. Bạn không được sửa!";
                }
                else
                {
                    //Lua THA_CVDON_THULY
                    int loai_don = 0, nguoi_lam_don = 0;
                    THA_CVDON_THULY objTL = null;
                    if (ThuLyId > 0)
                    {
                        try
                        {
                            objTL = dt.THA_CVDON_THULY.Where(x => x.ID == ThuLyId).Single<THA_CVDON_THULY>();
                            objTL.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            objTL.NGAYSUA = DateTime.Now;
                            IsUpdate = true;
                        }
                        catch (Exception ex)
                        {
                            objTL = new THA_CVDON_THULY();
                            objTL.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            objTL.NGAYTAO = DateTime.Now;
                        }
                    }
                    else
                    {
                        objTL = new THA_CVDON_THULY();
                        objTL.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        objTL.NGAYTAO = DateTime.Now;
                    }


                    objTL.BIANID = BiAnID;
                    objTL.VUANID = VuAnID;

                    objTL.LOAIDON = Convert.ToDecimal(rdLoaiDon.SelectedValue);
                    objTL.NGUOILAMDON = Convert.ToDecimal(rdNguoiLamDon.SelectedValue);
                    loai_don = Convert.ToInt16(rdLoaiDon.SelectedValue);
                    nguoi_lam_don = Convert.ToInt16(rdNguoiLamDon.SelectedValue);
                    switch (loai_don)
                    {
                        case 0:
                            //cong van
                            loai_thu_ly = "công văn";
                            objTL.CV_SO = txtSoCongVan.Text;
                            objTL.CV_NGAY = (String.IsNullOrEmpty(txtNgayCongVan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayCongVan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                            objTL.CV_TENCOQUAN = txtTenCoQuan.Text.Trim();
                            objTL.CV_DIACHI = txtDiaChi.Text.Trim();
                            objTL.CV_NGUOIKY = txtNguoiKy.Text.Trim();
                            objTL.CV_CHUCVU = txtChucVu.Text.Trim();
                            break;
                        case 1:
                            //don
                            loai_thu_ly = "đơn";
                            objTL.SOTHULY = txtDon_SoThuLy.Text;
                            objTL.NGAYTHULY = (String.IsNullOrEmpty(txtDon_NgayThuLy.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtDon_NgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                            switch (nguoi_lam_don)
                            {
                                case 0:
                                    //bi an                            
                                    objTL.DON_NGAY = (String.IsNullOrEmpty(txtDon_NgayLamCongVan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtDon_NgayLamCongVan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                    break;
                                case 1:
                                    //nguoi than
                                    objTL.DON_HOTEN = txtDon_NguoiLamDon.Text;
                                    objTL.DON_NGAYSINH = (String.IsNullOrEmpty(txtDon_NgaySinh.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtDon_NgaySinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                                    objTL.DON_CMND = txtDon_CMND.Text.Trim();
                                    objTL.DON_QUANHE = txtDon_QuanHeVoiBiAn.Text.Trim();
                                    objTL.DON_HKTT = txtDon_HoKhauTT.Text.Trim();
                                    objTL.DON_TAMTRU = txtDon_TamTru.Text.Trim();
                                    objTL.DON_QUOCTICHID = Convert.ToDecimal(dropDon_QuocTich.SelectedValue);
                                    break;
                            }
                            break;
                    }

                    objTL.YEUCAUID = Convert.ToDecimal(dropYeuCau.SelectedValue);
                    objTL.LYDOID = Convert.ToDecimal(dropLyDo.SelectedValue);

                    objTL.YKIENPHUONGXA = txtYKien.Text;

                    /*
                    1. Người tạo/sửa: VNPT-Nguyễn Đăng HUy Hoàng (Tên đơn vị + Tên người thực hiện)
                    2. Mô tả: lddalwuuw trữ thông tin file đính kèm
                    3. Thời gian tạo/sửa: 18-09-2025 16:05 (định dạng "DD-MM-YYYY HH24:MI")
                    */
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
                            objTL.QT_FILE_ID = qtFile.ID;
                            hddFilePath.Value = "";
                        }
                    }
                    catch { }

                    objTL.NGAYNHAN = (String.IsNullOrEmpty(txtNgayNhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    objTL.NGUOINHANID = Convert.ToDecimal(dropNguoiNhan.SelectedValue);
                    if (!IsUpdate)
                    {
                        objTL.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        dt.THA_CVDON_THULY.Add(objTL);
                    }
                    dt.SaveChanges();
                    lstMsgTop.Text = "Cập nhật thông tin thụ lý " + loai_thu_ly + " cho bị án thành công!";
                    ClearForm();
                    LoadDsThuLy();
                }
            }
            else
            {
                lbthongbao.Text = "Bạn chưa nhập mục '3.Quyết định thi hành án' !";
            }
        }
        void ClearForm()
        {
            txtChucVu.Text = txtDiaChi.Text = txtDon_CMND.Text = txtDon_HoKhauTT.Text = txtDon_NgayLamCongVan.Text = "";
            txtDon_NgaySinh.Text = txtDon_NgayThuLy.Text = txtDon_NguoiLamDon.Text = txtDon_QuanHeVoiBiAn.Text = txtDon_SoThuLy.Text = "";
            txtDon_TamTru.Text = txtNgayCongVan.Text ="";
            txtNgayNhan.Text = txtNguoiKy.Text = txtSoCongVan.Text = txtTenCoQuan.Text = txtYKien.Text = "";
            rdLoaiDon.SelectedValue = rdNguoiLamDon.SelectedValue = "0";
            lttGroup.Text = "Thông tin công văn";
            pnCongVanEdit.Visible = true;
            pnDon.Visible = false;
            pnRowLoai.Visible = false;
            hddThuLyID.Value = "0";
        }
        //------------------------------
        void LoadDsThuLy()
        {
            THA_CVDON_THULY_BL objBL = new THA_CVDON_THULY_BL();
            DataTable tbl = objBL.GetThuLyByBiAnID(VuAnID, BiAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.Visible = true;
                rpt.DataSource = tbl;
                rpt.DataBind();
            }
            else
            {
                rpt.Visible = false;
                // lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ThuLyID = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "sua":
                    ClearForm();
                    hddThuLyID.Value = ThuLyID.ToString();
                    hddFilePath.Value = "";
                    LoadThongTinThuLy();
                    break;
                case "Xoa":
                    xoa(ThuLyID);
                    break;
                case "Download":
                    try
                    {
                        THA_CVDON_THULY donThuLy = dt.THA_CVDON_THULY.Where(x => x.ID == ThuLyID).FirstOrDefault();
                        if (donThuLy.QT_FILE_ID != null)
                        {
                            QT_FILE qtFileGet = DataExtensions.FindById<QT_FILE>(donThuLy.QT_FILE_ID.Value);
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
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                ImageButton lblDownload = (ImageButton)e.Item.FindControl("lblDownload");


                int THA_TLCVid = (string.IsNullOrEmpty(rowView["ID"] + "")) ? 0 : Convert.ToInt16(rowView["ID"] + "");
                THA_CVDON_THULY oND = dt.THA_CVDON_THULY.Where(x => x.ID == THA_TLCVid).FirstOrDefault();
                lblDownload.Visible = !string.IsNullOrEmpty(rowView["FILE_ID"] + "");
                if (oND != null)
                {
                    THA_CVDON_KQGQ obj = null;
                    try
                    {
                        obj = dt.THA_CVDON_KQGQ.Where(x => x.CVDONID == THA_TLCVid).Single<THA_CVDON_KQGQ>();
                    }
                    catch (Exception ex) { }
                    //Kiem tra xem có Ket qua giai quyet thi khong duoc xoa
                    if (obj != null)
                    {
                        lbtXoa.Visible = false;
                        lblSua.Text = "Chi tiết";
                    }
                    else
                    {
                        lbtXoa.Visible = true;
                        lblSua.Text = "Sửa";
                    }
                }

                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = hddToaGiaiQuyetID.Value.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                    cmdSave.Visible = false;
                }
            }
        }
        public void xoa(decimal id)
        {
            THA_CVDON_KQGQ obj = dt.THA_CVDON_KQGQ.Where(x => x.CVDONID == id).SingleOrDefault<THA_CVDON_KQGQ>();
            if (obj != null)
            {
                lbthongbao.Text = "Đã  có Kết quả giải quyết công văn/đơn không được xóa";
            }
            else
            {
                THA_CVDON_THULY oCVDON = dt.THA_CVDON_THULY.Where(x => x.ID == id).FirstOrDefault();

                if (oCVDON != null)
                {

                    dt.THA_CVDON_THULY.Remove(oCVDON);
                    dt.SaveChanges();
                }
                // xoa file MinIO
                if (oCVDON.QT_FILE_ID != null)
                {
                    QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oCVDON.QT_FILE_ID.Value);
                    if (qtFileDelete != null)
                    {
                        qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_THA + ".";
                        QT_FILE_BL fileH = new QT_FILE_BL();
                        fileH.DeleteFileLogic(qtFileDelete);
                        hddFilePath.Value = "";
                    }
                }
                lbthongbao.Text = "Xóa thành công!";
                //gán lại bianid và vuanid
                BiAnID = Convert.ToDecimal(hddBiAnID.Value);
                VuAnID = Convert.ToDecimal(hddVuAnID.Value);
                LoadDsThuLy();
            }
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
                }
            }
            catch (Exception ex) { lbthongbao.Text = "Lỗi: " + ex.Message; }
        }
    }
}
