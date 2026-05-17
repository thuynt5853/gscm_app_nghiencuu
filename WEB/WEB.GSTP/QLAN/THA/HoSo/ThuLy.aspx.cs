using BL.GSTP;
using BL.GSTP.AHC;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.QUANTRI;
using BL.GSTP.Quantri;
using BL.GSTP.THA;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity.Migrations;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.THA.HoSo
{
    public partial class ThuLy : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrUserID = 0, VuAnID = 0, BiAnID = 0;
        public string NgaySoSanh = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            ltSoThuLy.Text = "<span style='color:red'>(*)</span>";
            ltNgayThuLy.Text = "<span style='color:red'>(*)</span>";
            ltTuNgay.Text = "<span style='color:red'>(*)</span>";
            ltDenNgay.Text = "<span style='color:red'>(*)</span>";
            // chan dien thong tin thu ly khi co hinhf phat tien
            
            
            if (CurrUserID > 0)
            {
                txtMaThuLy.Enabled =txtMaBiAn.Enabled= txtDiaChi.Enabled = false;
                //dropBiAn.Enabled = false;
                if (!IsPostBack)
                {
                    
                    hddBiAnID.Value = BiAnID.ToString();
                    CheckQuyen(BiAnID);
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    if (BiAnID > 0)
                    {
                        pn.Visible = true;
                        LoadCombobox();
                        LoadThongTinBiAn();

                        THA_BIAN biAn = dt.THA_BIAN.Where(x => x.ID == BiAnID).FirstOrDefault();
                        THA_BIAN biAnUythac = null;
                        if (biAn.UYTHAC_DETAIL_ID != null || biAn.UYTHAC_DETAIL_ID != 0)
                        {
                            biAnUythac = dt.THA_BIAN.Where(x => x.IDBICANHETHONG == biAn.IDBICANHETHONG && x.IDVUANHETHONG != 0).FirstOrDefault();
                        }
                        else
                        {
                            biAnUythac = biAn;
                        }
                        LoadGrid();
                        THA_VUAN_BL thaVuAnBL = new THA_VUAN_BL();
                        if (biAn != null)
                        {
                            if (thaVuAnBL.EXIST_PHATTIEN_AHS((decimal)biAnUythac.IDVUANHETHONG, (decimal)biAnUythac.IDBICANHETHONG))
                            {
                                lbthongbao.Text = "Bị án có đã có hình phạt tiền, không được nhập thụ lý";
                                cmdUpdate.Visible = false;
                            }
                        }
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
        void CheckQuyen(Decimal BiAnID)
        {
            try
            {
                THA_BIAN obj = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
                if (obj != null)
                {
                    Decimal THA_VuAnID = (decimal)obj.VUANID;
                    THA_VUAN objVA = dt.THA_VUAN.Where(x => x.ID == THA_VuAnID).Single<THA_VUAN>();
                    NgaySoSanh = (objVA.BA_ST_NGAYHIEULUC == null || objVA.BA_ST_NGAYHIEULUC == DateTime.MinValue) ? "" : ((DateTime)objVA.BA_ST_NGAYHIEULUC).ToString("dd/MM/yyyy", cul);
                    //// ((DateTime)objVA.BA_ST_NGAYHIEULUC).ToString("dd/MM/yyyy", cul);
                    txtNgayBanAnCoHieuLuc.Text = NgaySoSanh;

                    THA_BIAN_QUYETDINH data = dt.THA_BIAN_QUYETDINH.FirstOrDefault(x => x.BIANID == BiAnID);
                    if (data != null)
                    {
                        lbthongbao.Text = "Bị án đã có quyết định thi hành án. Không được thay đổi thông tin!";
                        cmdUpdate.Visible = false;
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message.ToString(); }
        }
        private void LoadCombobox()
        {
            dropTruongHopThuLy.Items.Clear();   
            dropTruongHopThuLy.Items.Add(new ListItem("Thụ lý mới", "0"));
            dropTruongHopThuLy.Items.Add(new ListItem("Thụ lý mới do có ủy thác Thi hành án", "1"));
            //kiểm tra nếu có ủy thác THA thì gợi ý là thụ lý mới do có ủy thác THA
            THA_BIAN obBian = dt.THA_BIAN.Where(x => x.ID == BiAnID).FirstOrDefault();
            THA_UYTHAC_DETAIL objDe = dt.THA_UYTHAC_DETAIL.Where(x => x.ID == obBian.UYTHAC_DETAIL_ID).FirstOrDefault();
            if(objDe!=null)
            {
                dropTruongHopThuLy.SelectedValue = "1";
            }
            else
            {
                dropTruongHopThuLy.SelectedValue = "0";
            }
        }
        void LoadThongTinBiAn()
        {
            dropBiAn.Items.Clear();
            BiAnID = Convert.ToDecimal(hddBiAnID.Value);
            THA_BIAN obj = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
            if (obj != null)
            {
                VuAnID = (decimal)obj.VUANID;
                hddVuAnID.Value = VuAnID.ToString();
                dropBiAn.Items.Add(new ListItem(obj.HOTEN, obj.ID.ToString()));
                if (obj != null && obj.HKTT != null)
                {
                    var objHCs = dt.DM_HANHCHINH.Where(x => x.ID == obj.HKTT).ToList();
                    if (objHCs.Count > 0)
                    {
                        var objHC = objHCs.Single<DM_HANHCHINH>();
                        txtDiaChi.Text = objHC.TEN;
                    }
                }
            }
        }
        private void ResetControls()
        {
            txtNgayBanAnCoHieuLuc.Text = "";
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";
            txtNgaythuly.Text = "";
            cb_uttp.Checked = false;
            khongThiHanhAn.Visible = false;
            ltSoThuLy.Text = "<span style='color:red'>(*)</span>";
            ltNgayThuLy.Text = "<span style='color:red'>(*)</span>";
            ltTuNgay.Text = "<span style='color:red'>(*)</span>";
            ltDenNgay.Text = "<span style='color:red'>(*)</span>";
            txtGhichu.Text = "";
            // txtND_HKTT_Chitiet.Text = "";
            txtNgayThongKe.Text = "";
            txtLiDo.Text = "";
            txtDiaChi.Text = "";
            hddid.Value = "0";
            
            // Reset file đính kèm
            hddFilePath.Value = "";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }
        //-----------------------------
        void LoadInfoThuLy()
        {
            BiAnID = Convert.ToDecimal(hddBiAnID.Value);
            try
            {
                THA_THULY obj = dt.THA_THULY.Where(x => x.BIANID == BiAnID).Single<THA_THULY>();
                if (obj != null)
                {
                    hddVuAnID.Value = obj.VUANID + "";
                    hddBiAnID.Value = obj.BIANID + "";
                    txtMaThuLy.Text = obj.MATHULY;
                    txtNgaythuly.Text = obj.NGAYTHULY != null ? ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul) : "";
                    txtSoThuly.Text = obj.SOTHULY;

                    String date_temp = (obj.THOIHANTUNGAY == null || obj.THOIHANTUNGAY == DateTime.MinValue) ? "" : ((DateTime)obj.THOIHANTUNGAY).ToString("dd/MM/yyyy", cul);
                    txtTuNgay.Text = date_temp;

                    date_temp = (obj.THOIHANDENNGAY == null || obj.THOIHANDENNGAY == DateTime.MinValue) ? "" : ((DateTime)obj.THOIHANDENNGAY).ToString("dd/MM/yyyy", cul);
                    txtDenNgay.Text = date_temp;

                    txtGhichu.Text = obj.GHICHU;
                }
            }
            catch (Exception ex) { }
        }
        private bool CheckValid()
        {
            if (!cb_uttp.Checked)
            {
                if ((String.IsNullOrEmpty(txtSoThuly.Text.Trim())))
                {
                    lbthongbao.Text = "Thông tin số thụ lý không được để trống";
                    txtSoThuly.Focus();
                    return false;
                }
                if ((String.IsNullOrEmpty(txtNgaythuly.Text.Trim())))
                {
                    lbthongbao.Text = "Thông tin ngày thụ lý không được để trống";
                    txtNgaythuly.Focus();
                    return false;
                }
                if ((String.IsNullOrEmpty(txtTuNgay.Text.Trim())))
                {
                    lbthongbao.Text = "Thông tin từ ngày không được để trống";
                    txtTuNgay.Focus();
                    return false;
                }
                if ((String.IsNullOrEmpty(txtDenNgay.Text.Trim())))
                {
                    lbthongbao.Text = "Thông tin đến ngày không được để trống";
                    txtDenNgay.Focus();
                    return false;
                }
            } else
            {
                if ((String.IsNullOrEmpty(txtNgayThongKe.Text.Trim())))
                {
                    lbthongbao.Text = "Thông tin ngày thống kê không được để trống";
                    txtNgayThongKe.Focus();
                    return false;
                }
                if ((String.IsNullOrEmpty(txtLiDo.Text.Trim())))
                {
                    lbthongbao.Text = "Thông tin lí do không thi hành án không được để trống";
                    txtLiDo.Focus();
                    return false;
                }
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!CheckValid()) return;
            DateTime? date_temp;
            Boolean IsUpdate = false;
            Decimal VuAnId = (String.IsNullOrEmpty(hddVuAnID.Value + "")) ? 0 : Convert.ToDecimal(hddVuAnID.Value);
            BiAnID = Convert.ToDecimal(dropBiAn.SelectedValue);// Convert.ToDecimal(hddBiAnID.Value);
            THA_THULY obj = new THA_THULY();
            try
            {
                if (BiAnID > 0)
                {
                    obj = dt.THA_THULY.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnId).Single<THA_THULY>();
                    IsUpdate = true;
                }
                else
                    obj = new THA_THULY();
            }
            catch (Exception ex) { obj = new THA_THULY(); }

            obj.BIANID = BiAnID;
            obj.VUANID = VuAnId;

            obj.TRUONGHOPTHULY = Convert.ToDecimal(dropTruongHopThuLy.SelectedValue);
            obj.SOTHULY = txtSoThuly.Text.Trim();
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

            //------------------------------------------
            date_temp = (String.IsNullOrEmpty(txtNgaythuly.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythuly.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYTHULY = date_temp;

            date_temp = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.THOIHANTUNGAY = date_temp;
            date_temp = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.THOIHANDENNGAY = date_temp;

            /*
            1. Người tạo/sửa: VNPT-Nguyễn Đăng HUy Hoàng (Tên đơn vị + Tên người thực hiện)
            2. Mô tả: lưu thêm các trường mới cập nhật
            3. Thời gian tạo/sửa: 17-09-2025 16:05 (định dạng "DD-MM-YYYY HH24:MI")
            */
            obj.GHICHU = txtGhichu.Text;
            obj.IS_KHONGTHA = cb_uttp.Checked ? 1: 0;
            obj.LIDO_KHONGTHA = txtLiDo.Text;
            obj.NGAYTHONGKE = (String.IsNullOrEmpty(txtNgayThongKe.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayThongKe.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            //--------------------------------
            if (IsUpdate)
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            else
            {
                Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");

                THA_THULY_BL objBL = new THA_THULY_BL();
                THA_BIAN_BL objBABL = new THA_BIAN_BL();
                obj.TOAANID = ToaAnID;
                obj.MATHULY = objBL.GetNewThuTu() + "";
                //chưa gán TT trong THA_THULY
                //obj.TT = Convert.ToDecimal(objBL.GetNewThuTu(ToaAnID).ToString());
                //obj.MATHULY = ENUM_LOAIVUVIEC.AN_THA + Session[ENUM_SESSION.SESSION_MADONVI] + objBL.GetNewThuTu(ToaAnID).ToString();
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                dt.THA_THULY.Add(obj);
                //dt.SaveChanges();
                //BiAnID = obj.ID;

                //tự sinh mã bị án
                decimal MABICAN_TUSINH = objBL.GetMABIANTuSinh();
                BiAnID = Convert.ToDecimal(hddBiAnID.Value);
                THA_BIAN obaj = dt.THA_BIAN.Where(x => x.ID == obj.BIANID).FirstOrDefault<THA_BIAN>();
                obaj.MABICAN = MABICAN_TUSINH + "";
                //obaj.TT = objBABL.GETNEWTT(ToaAnID);
                //obaj.MABICAN = ENUM_LOAIVUVIEC.AN_THA + Session[ENUM_SESSION.SESSION_MADONVI] + objBABL.GETNEWTT(ToaAnID).ToString();
                dt.SaveChanges();
            }
            THA_VUAN objTHA = dt.THA_VUAN.Where(x => x.ID == obj.VUANID).FirstOrDefault();
            if (objTHA != null)
            {
                DateTime? date_Ngaythuly;
                date_Ngaythuly = (String.IsNullOrEmpty(txtNgayBanAnCoHieuLuc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayBanAnCoHieuLuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (date_Ngaythuly != DateTime.MinValue)
                {
                    objTHA.BA_ST_NGAYHIEULUC = date_Ngaythuly;
                }
                dt.SaveChanges();
                
            }
            hddBiAnID.Value = BiAnID.ToString();
            lbthongbao.Text = "Đã cập nhật xong thụ lý cho bị án " + dropBiAn.SelectedItem.Text;
            if (!IsUpdate)
            {
                updateMaBiAn_AHS_BICABICAO(BiAnID);
            }
            LoadGrid();
            ResetControls();
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = hddFilePath.Value = "";
            txtMaThuLy.Text = txtNgaythuly.Text = txtSoThuly.Text = "";
            txtDiaChi.Text = txtGhichu.Text = "";
            txtDenNgay.Text = txtTuNgay.Text = "";
        }
        public void LoadGrid()
        {
            BiAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_BIAN obj = dt.THA_BIAN.Where(x => x.ID == BiAnID).Single<THA_BIAN>();
            THA_THULY_BL oBL = new THA_THULY_BL();
            DataTable oDT = null;
            if (obj != null)
            {
                VuAnID = (decimal)obj.VUANID;
                hddVuAnID.Value = VuAnID.ToString();               
                oDT = oBL.THA_THULY_GETLIST(BiAnID,VuAnID);
            }

            if (oDT.Rows.Count > 0)
            {
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
                cmdUpdate.Visible = false;
            }
            else
            {
                pndata.Visible = false;
                // Hiển thị nút Lưu khi không có dữ liệu trong DataGrid
                cmdUpdate.Visible = true;
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal THA_TLid = Convert.ToDecimal(e.CommandArgument.ToString());
            decimal bianID = 0;
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    hddFilePath.Value = "";
                    loadedit(THA_TLid);
                    break;
                case "Xoa":
                    //Kiểm tra xem có quyên sửa xóa không
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    // Kiểm tra có Quyết định thi hành án chưa
                    THA_THULY oND = dt.THA_THULY.Where(x => x.ID == THA_TLid).FirstOrDefault();
                    if (oND != null)
                    {
                        bianID = oND.BIANID + "" == "" ? 0 : (decimal)oND.BIANID;
                        Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                        THA_BIAN_QUYETDINH obj = null;
                        try
                        {
                            obj = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID
                                                                                   && x.VUANID == oND.VUANID
                                                                                   && x.TOAANID == ToaAnID
                                                                                ).Single<THA_BIAN_QUYETDINH>();
                        }
                        catch (Exception ex) { }


                        if (obj != null)
                        {
                            lbthongbao.Text = "Bị án đã có Quyết định Thi hành án. Không được xóa.";
                            return;
                        }
                    }
                    xoa(THA_TLid);
                    updateMaBiAnSauKhiXoaThuLy(bianID);
                    LoadGrid();
                    ResetControls();
                    break;
                case "Download":
                    try
                    {
                        THA_THULY thuLy = dt.THA_THULY.Where(x => x.ID == THA_TLid).FirstOrDefault();
                        if (thuLy.QT_FILE_ID != null)
                        {
                            QT_FILE qtFileGet = DataExtensions.FindById<QT_FILE>(thuLy.QT_FILE_ID.Value);
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
        private void updateMaBiAn_AHS_BICABICAO(decimal bianID)
        {
            THA_BIAN obaj = dt.THA_BIAN.Where(x => x.ID == bianID).FirstOrDefault<THA_BIAN>();
            AHS_BICANBICAO obcbc = dt.AHS_BICANBICAO.Where(x => x.ID == obaj.IDBICANHETHONG).FirstOrDefault<AHS_BICANBICAO>();
            if(obcbc != null)
            {
                obcbc.MABICAN = obaj.MABICAN;
                dt.SaveChanges();
            }
        }
        private void updateMaBiAnSauKhiXoaThuLy(decimal bianID)
        {
            THA_BIAN obaj = dt.THA_BIAN.Where(x => x.ID == bianID).FirstOrDefault<THA_BIAN>();
            AHS_BICANBICAO obcbc = dt.AHS_BICANBICAO.Where(x => x.ID == obaj.IDBICANHETHONG).FirstOrDefault<AHS_BICANBICAO>();
            obaj.MABICAN = null;
            obcbc.MABICAN = null;
            dt.SaveChanges();
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
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

                // Kiểm tra có Quyết định thi hành án chưa
                decimal THA_TLid = (string.IsNullOrEmpty(rowView["ID"] + "")) ? 0 : Convert.ToDecimal(rowView["ID"] + "");
                THA_THULY oND = dt.THA_THULY.Where(x => x.ID == THA_TLid).FirstOrDefault();
                if (oND != null)
                {
                    Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                    THA_BIAN_QUYETDINH obj = null;
                    try
                    {
                        obj = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == oND.BIANID
                                                                               && x.VUANID == oND.VUANID
                                                                               && x.TOAANID == ToaAnID
                                                                            ).Single<THA_BIAN_QUYETDINH>();
                    }
                    catch (Exception ex) { }
                    //Kiem tra xem có Uy thac Thi hanh an chua neu co roi khong duoc xoa
                    THA_UYTHAC_QUYETDINH oQDUT = null;
                    try
                    {
                        oQDUT = dt.THA_UYTHAC_QUYETDINH.Where(x => x.BIANID == oND.BIANID
                                                                               && x.VUANID == oND.VUANID
                                                                            ).Single<THA_UYTHAC_QUYETDINH>();
                    }
                    catch (Exception ex) { }
                    lblDownload.Visible = !string.IsNullOrEmpty(rowView["FILE_ID"] + "");
                    if (obj != null || oQDUT != null)
                    {
                        lblSua.Visible = lbtXoa.Visible = false;
                    }
                    else
                    {
                        lblSua.Visible = true;
                        lbtXoa.Visible = true;
                    }
                }
                string toagiaiquyetID = rowView["TOA_GIAIQUYET_ID"] + "";
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }
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
        public void xoa(decimal id)
        {
            decimal bianID = 0;
            THA_THULY oND = dt.THA_THULY.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                bianID = oND.BIANID + "" == "" ? 0 : (decimal)oND.BIANID;
                Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                // Kiểm tra có Quyết định thi hành án chưa
                THA_BIAN_QUYETDINH obj = null;
                try
                {
                    obj = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == bianID
                                                                           && x.VUANID == oND.VUANID
                                                                           && x.TOAANID == ToaAnID
                                                                        ).Single<THA_BIAN_QUYETDINH>();
                }
                catch (Exception ex) { }

                if (obj != null)
                {
                    lbthongbao.Text = "Bị án đã có Quyết định Thi hành án. Không được xóa.";
                    return;
                }
                else
                {
                    // xoa file MinIO
                    if (oND.QT_FILE_ID != null)
                    {
                        QT_FILE qtFileDelete = DataExtensions.FindById<QT_FILE>(oND.QT_FILE_ID.Value);
                        if (qtFileDelete != null)
                        {
                            qtFileDelete.DESCRIPTION = "Tài khoản " + Session[ENUM_SESSION.SESSION_USERNAME] + " đã xóa file tại form BanAnSoTham " + ENUM_LOAIAN.AN_THA + ".";
                            QT_FILE_BL fileH = new QT_FILE_BL();
                            fileH.DeleteFileLogic(qtFileDelete);
                        }
                    }
                    dt.THA_THULY.Remove(oND);
                    dt.SaveChanges();
                }
            }
            lbthongbao.Text = "Xóa thành công!";
        }
        void loadedit(decimal THA_TLid)
        {
            try
            {
                THA_THULY obj = dt.THA_THULY.Where(x => x.ID == THA_TLid).Single<THA_THULY>();
                if (obj != null)
                {
                    hddVuAnID.Value = obj.VUANID + "";
                    hddBiAnID.Value = obj.BIANID + "";
                    txtMaThuLy.Text = obj.MATHULY;
                    THA_BIAN obaj = dt.THA_BIAN.Where(x => x.ID == obj.BIANID).Single<THA_BIAN>();
                    //hiển thị mã bị can
                    if (obaj != null)
                    {
                        txtMaBiAn.Text = obaj.MABICAN;
                    }
                    THA_VUAN vuAn = dt.THA_VUAN.Where(x => x.ID == obj.VUANID).Single<THA_VUAN>();
                    //hiển thị ngay ban an hieu luc
                    if (vuAn != null)
                    {
                        txtNgayBanAnCoHieuLuc.Text = vuAn.BA_ST_NGAYHIEULUC != null ? ((DateTime)vuAn.BA_ST_NGAYHIEULUC).ToString("dd/MM/yyyy", cul) : "";
                    }
                    txtNgaythuly.Text = obj.NGAYTHULY != null ? ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul) : "";
                    txtSoThuly.Text = obj.SOTHULY;

                    String date_temp = (obj.THOIHANTUNGAY == null || obj.THOIHANTUNGAY == DateTime.MinValue) ? "" : ((DateTime)obj.THOIHANTUNGAY).ToString("dd/MM/yyyy", cul);
                    txtTuNgay.Text = date_temp;

                    date_temp = (obj.THOIHANDENNGAY == null || obj.THOIHANDENNGAY == DateTime.MinValue) ? "" : ((DateTime)obj.THOIHANDENNGAY).ToString("dd/MM/yyyy", cul);
                    txtDenNgay.Text = date_temp;

                    txtGhichu.Text = obj.GHICHU;
                    cb_uttp.Checked = obj.IS_KHONGTHA != null && obj.IS_KHONGTHA == 1;
                    khongThiHanhAn.Visible = obj.IS_KHONGTHA != null && obj.IS_KHONGTHA == 1;
                    if (cb_uttp.Checked)
                    {
                        ltSoThuLy.Text = "";
                        ltNgayThuLy.Text = "";
                        ltTuNgay.Text = "";
                        ltDenNgay.Text = "";
                    }
                    date_temp = (obj.NGAYTHONGKE == null || obj.NGAYTHONGKE == DateTime.MinValue) ? "" : ((DateTime)obj.NGAYTHONGKE).ToString("dd/MM/yyyy", cul);
                    txtNgayThongKe.Text = date_temp;
                    txtLiDo.Text = obj.LIDO_KHONGTHA;
                    // hien thi nut luu
                    cmdUpdate.Visible = true;
                }
            }
            catch (Exception ex) { }
        }
        protected void Unnamed_CheckedChanged(object sender, EventArgs e)
        {
            if (cb_uttp.Checked == false)
            {
                khongThiHanhAn.Visible = false;
                ltSoThuLy.Text = "<span style='color:red'>(*)</span>";
                ltNgayThuLy.Text = "<span style='color:red'>(*)</span>";
                ltTuNgay.Text = "<span style='color:red'>(*)</span>";
                ltDenNgay.Text = "<span style='color:red'>(*)</span>";
                txtLiDo.Text = "";
                txtNgayThongKe.Text = "";
            }
            else
            {
                khongThiHanhAn.Visible = true;
                ltSoThuLy.Text = "";
                ltNgayThuLy.Text = "";
                ltTuNgay.Text = "";
                ltDenNgay.Text = "";
            }
        }

    }
}