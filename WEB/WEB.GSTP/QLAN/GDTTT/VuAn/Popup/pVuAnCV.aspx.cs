using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Globalization;

using Module.Common;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;

namespace WEB.GSTP.QLAN.GDTTT.Giaiquyet.Popup
{
    public partial class pVuAnCV : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        String UserName = "";
        String SessionTTV = "pGDTTT_TTV";
        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");

            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadComponent();
                    LoadThongTinVuAn();
                    if (Request["type"] == null)
                    {
                        DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                        rptNguyenDon.DataSource = tbl;
                        rptNguyenDon.DataBind();

                        tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
                        rptBiDon.DataSource = tbl;
                        rptBiDon.DataBind();

                        tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                        rptDsKhac.DataSource = tbl;
                        rptDsKhac.DataBind();
                    }
                    else hddThuLyLaiVuAnID.Value = Request["vID"] +"";
                }
            }
            else Response.Redirect("/Login.aspx");
        }

        void LoadThongTinVuAn()
        {
            Decimal CurrVuAnID = (String.IsNullOrEmpty(Request["vID"]+"")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            if (CurrVuAnID > 0)
            {
                hddVuAnID.Value = CurrVuAnID + "";
                GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single<GDTTT_VUAN>();
                if (objVA != null)
                {
                    Cls_Comon.SetValueComboBox(dropToaAn, objVA.TOAPHUCTHAMID);
                    Cls_Comon.SetValueComboBox(dropLoaiAn, objVA.LOAIAN);
                    LoadDMQuanHePL();
                    try { Cls_Comon.SetValueComboBox(dropQHPL, objVA.QHPL_DINHNGHIAID); } catch (Exception ex) { }
                  
                    //------------------------
                    LoadDsDuongSu(CurrVuAnID, rptNguyenDon, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    LoadDsDuongSu(CurrVuAnID, rptBiDon, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    LoadDsDuongSu(CurrVuAnID, rptDsKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);

                    //----------thong tin TTV/LD---------------------
                    txtNgayphancong.Text = (String.IsNullOrEmpty(objVA.NGAYPHANCONGTTV + "") || (objVA.NGAYPHANCONGTTV == DateTime.MinValue)) ? "" : ((DateTime)objVA.NGAYPHANCONGTTV).ToString("dd/MM/yyyy", cul);
                    Decimal thamtravien = (String.IsNullOrEmpty(objVA.THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(objVA.THAMTRAVIENID);
                    try { Cls_Comon.SetValueComboBox(dropTTV, thamtravien); } catch (Exception ex) { }
                    if (thamtravien > 0)
                        GetAllLanhDaoNhanBCTheoTTV(thamtravien);
                    try { Cls_Comon.SetValueComboBox(dropLanhDao, objVA.LANHDAOVUID); } catch (Exception ex) { }
                    try { Cls_Comon.SetValueComboBox(dropThamPhan, objVA.THAMPHANID); } catch (Exception ex) { }
                    txtNgayNhanTieuHS.Text = (String.IsNullOrEmpty(objVA.NGAYTTVNHAN_THS + "") || (objVA.NGAYTTVNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)objVA.NGAYTTVNHAN_THS).ToString("dd/MM/yyyy", cul);
                    txtNgayGDNhanHS.Text = (String.IsNullOrEmpty(objVA.NGAYVUGDNHAN_THS + "") || (objVA.NGAYVUGDNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)objVA.NGAYVUGDNHAN_THS).ToString("dd/MM/yyyy", cul);
                    txtGhiChu.Text = objVA.GHICHU;
                }
            }
        }

       
        //-------------------------------------------
        void LoadComponent()
        {
            LoadDropToaAn();
            LoadLoaiAnTheoVu();
            LoadDMQuanHePL();
            LoadDropLanhDao();
            LoadDropTTV();
            LoadThamPhan();
            hddGUID.Value = Guid.NewGuid().ToString();
            //---------------
            LoadDropSoLuong(dropSoND, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            LoadDropSoLuong(dropSoBD, ENUM_DANSU_TUCACHTOTUNG.BIDON);
            LoadDropSoLuong(dropSoDSKhac, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
        }

        void LoadDropToaAn()
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAn.DataSource = dtTA;
            dropToaAn.DataTextField = "MA_TEN";
            dropToaAn.DataValueField = "ID";
            dropToaAn.DataBind();
            dropToaAn.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadLoaiAnTheoVu()
        {
            dropLoaiAn.Items.Clear();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PhongBanID).FirstOrDefault();
            if (obj.ISHINHSU == 1) dropLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
            if (obj.ISDANSU == 1) dropLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
            if (obj.ISHANHCHINH == 1) dropLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
            if (obj.ISHNGD == 1) dropLoaiAn.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
            if (obj.ISKDTM == 1) dropLoaiAn.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
            if (obj.ISLAODONG == 1) dropLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
            //if (obj.ISPHASAN == 1) dropLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
            //if (dropLoaiAn.Items.Count == 1)
            dropLoaiAn.SelectedIndex = 0;
        }
        protected void dropLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDMQuanHePL();
            Cls_Comon.SetFocus(this, this.GetType(), dropQHPL.ClientID);
        }
        void LoadDMQuanHePL()
        {
            int LoaiAn = Convert.ToInt16(dropLoaiAn.SelectedValue);
            List<GDTTT_DM_QHPL> lst = dt.GDTTT_DM_QHPL.Where(x => x.LOAIAN == LoaiAn).ToList();
            if (lst != null && lst.Count > 0)
            {
                dropQHPL.Items.Clear();
                dropQHPL.DataSource = lst;
                dropQHPL.DataTextField = "TenQHPL";
                dropQHPL.DataValueField = "ID";
                dropQHPL.DataBind();
                dropQHPL.Items.Insert(0, new ListItem("Chọn", "0"));
            }
        }
        //-----------------------      
        void LoadDropLanhDao()
        {
            dropLanhDao.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tblLanhDao = obj.DM_CANBO_GetAllVuTruong_PVT(PhongBanID);
            if (tblLanhDao != null && tblLanhDao.Rows.Count > 0)
            {
                dropLanhDao.DataSource = tblLanhDao;
                dropLanhDao.DataValueField = "ID";
                dropLanhDao.DataTextField = "MA_TEN";
                dropLanhDao.DataBind();
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropLanhDao.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadDropTTV()
        {
            dropTTV.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tbl = obj.DM_CANBO_GetTTVTheoPhongBan(PhongBanID, "TTV");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTTV.DataSource = tbl;
                dropTTV.DataValueField = "CanBoID";
                dropTTV.DataTextField = "TenCanBo";
                dropTTV.DataBind();
                dropTTV.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                dropTTV.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void GetAllLanhDaoNhanBCTheoTTV(Decimal ThamTraVienID)
        {
            LoadDropLanhDao();
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            GDTTT_CACVU_CAUHINH_BL objBL = new GDTTT_CACVU_CAUHINH_BL();
            if (ThamTraVienID > 0)
            {
                DataTable tbl = objBL.GetLanhDaoNhanBCTheoTTV(PhongBanID, ThamTraVienID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    string strLDVID = tbl.Rows[0]["ID"] + "";
                    dropLanhDao.SelectedValue = strLDVID;
                }
            }
        }

        protected void dropTTV_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropTTV.SelectedValue != "0")
            {
                decimal thamtravien = Convert.ToDecimal(dropTTV.SelectedValue);
                GetAllLanhDaoNhanBCTheoTTV(thamtravien);
            }
            else
                LoadDropLanhDao();
            Cls_Comon.SetFocus(this, this.GetType(), dropLanhDao.ClientID);
        }
        protected void LoadThamPhan()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable tbl = oBL.CANBO_GETBYDONVI(ToaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropThamPhan.DataSource = tbl;
                dropThamPhan.DataValueField = "ID";
                dropThamPhan.DataTextField = "Hoten";
                dropThamPhan.DataBind();
                dropThamPhan.Items.Insert(0, new ListItem("Chọn", "0"));
            }
        }

        //----------------------------------------
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu();
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }

            GDTTT_VUAN obj = Save_VuAn();

            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, rptNguyenDon);
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.BIDON, rptBiDon);
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ, rptDsKhac);

            //------------------------
            lttMsgT.Text = lttMsg.Text = "Cập nhật dữ liệu thành công!";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }
        string CheckNhapDuongSu() 
        {
            String StrNguyenDon = "", StrBiDon = "";
            int count_item = 0;
            foreach (RepeaterItem item in rptNguyenDon.Items)
            {
                count_item++;
                TextBox txtTen = (TextBox)item.FindControl("txtTen");
                if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                    StrNguyenDon += (String.IsNullOrEmpty(StrNguyenDon) ? "" : ", ") + count_item.ToString();
            }
            if (!String.IsNullOrEmpty(StrNguyenDon))
                StrNguyenDon = " Nguyên đơn thứ " + StrNguyenDon;
            //------------------------
            count_item = 0;
            foreach (RepeaterItem item in rptBiDon.Items)
            {
                count_item++;
                TextBox txtTen = (TextBox)item.FindControl("txtTen");
                if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                    StrBiDon += (String.IsNullOrEmpty(StrBiDon) ? "" : ", ") + count_item.ToString();
            }
            if (!String.IsNullOrEmpty(StrBiDon))
                StrBiDon = " Bị đơn  thứ " + StrBiDon;

            //------------------------------
            String msg = "";
            if ((!String.IsNullOrEmpty(StrNguyenDon)) || (!String.IsNullOrEmpty(StrBiDon)))
            {
                msg = "Lưu ý: " + StrNguyenDon
                    + (string.IsNullOrEmpty(StrNguyenDon) ? "" : ";")
                    + StrBiDon + " chưa được nhập. Hãy kiểm tra lại!";
            }
            return msg;
        }
      
        GDTTT_VUAN Save_VuAn()
        {
            Decimal CurrVuAnID = (string.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value);

            GDTTT_VUAN obj = new GDTTT_VUAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrDonID = (String.IsNullOrEmpty(hddDonID.Value)) ? 0 : Convert.ToDecimal(hddDonID.Value + "");
            try
            {
                if (CurrVuAnID > 0)
                {
                    obj = dt.GDTTT_VUAN.Where(x => x.ID == CurrVuAnID).Single();
                    if (obj != null)
                        IsUpdate = true;
                }
            }catch(Exception ex) { }

            obj.PHONGBANID = PhongBanID;
            obj.TOAANID = CurrDonViID;
            obj.DONTHULYID = CurrDonID;

            //------Thong tin BA/QD------------------
            obj.ISANTRAODOICV = 1;
            obj.TONGDON = 0;
            obj.ARRNGUOIKHIEUNAI = obj.NGUOIKHIEUNAI = "";
            obj.ISANCHIDAO = obj.ISANQUOCHOI = 0;

            obj.LOAIAN = Convert.ToInt16(dropLoaiAn.SelectedValue);
            obj.TOAPHUCTHAMID = Convert.ToDecimal(dropToaAn.SelectedValue);
            obj.SOANSOTHAM = obj.SOANPHUCTHAM= "";
            obj.NGAYXUSOTHAM = obj.NGAYXUSOTHAM = DateTime.MinValue;
            obj.TOAANSOTHAM = 0;

            obj.QHPL_DINHNGHIAID = Convert.ToDecimal(dropQHPL.SelectedValue);
            obj.QHPL_THONGKEID = Convert.ToDecimal(dropQHPLThongKe.SelectedValue);

            //-----Thong tin TTV/LD------------------------
            obj.THAMTRAVIENID = Convert.ToDecimal(dropTTV.SelectedValue);
            obj.TENTHAMTRAVIEN = (dropTTV.SelectedValue == "0") ? "" : Cls_Comon.FormatTenRieng(dropTTV.SelectedItem.Text);
            DateTime date_temp = (String.IsNullOrEmpty(txtNgayNhanTieuHS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayNhanTieuHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYTTVNHAN_THS = date_temp;

            obj.LANHDAOVUID = Convert.ToDecimal(dropLanhDao.SelectedValue);
            date_temp = (String.IsNullOrEmpty(txtNgayGDNhanHS.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayGDNhanHS.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYVUGDNHAN_THS = date_temp;
            if (obj.NGAYTTVNHAN_THS != DateTime.MinValue)
                obj.ISHOSO = 1;

            obj.THAMPHANID = Convert.ToDecimal(dropThamPhan.SelectedValue);
            obj.GHICHU = txtGhiChu.Text.Trim();
            
            //---------------------------------
            if (!IsUpdate)
            {
                //Thông tin trạng thái thụ lý
                obj.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_MOI;
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = UserName;
                obj.ISTOTRINH = 0;
                dt.GDTTT_VUAN.Add(obj);
            }
            else
            {
                obj.NGAYSUA = DateTime.Now;
                obj.NGUOISUA = UserName;
            }
            //-----------------------
            dt.SaveChanges();
            hddVuAnID.Value = obj.ID.ToString();
            return obj;
        }

        void Update_DuongSu(GDTTT_VUAN objVA, string tucachtt, Repeater rpt)
        {
            GDTTT_VUAN_DUONGSU obj = new GDTTT_VUAN_DUONGSU();
            bool IsUpdate = false;
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            Decimal CurrDS = 0;
            String StrEditID = ",", StrUpdate = "";
            int soluongdong = 0, count_item = 1;
            Boolean IsNhapDiaChi = false;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    soluongdong = Convert.ToInt16(dropSoND.SelectedValue);
                    if (chkND.Checked)
                        IsNhapDiaChi = true;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    soluongdong = Convert.ToInt16(dropSoBD.SelectedValue);
                    if (chkBD.Checked)
                        IsNhapDiaChi = true;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    soluongdong = Convert.ToInt16(dropSoDSKhac.SelectedValue);
                    if (chkDSKhac.Checked)
                        IsNhapDiaChi = true;
                    break;
            }
            //-------------------------
            foreach (RepeaterItem item in rpt.Items)
            {
                IsUpdate = false;
                if (count_item <= soluongdong)
                {
                    #region Update duong su
                    TextBox txtTen = (TextBox)item.FindControl("txtTen");
                    TextBox txtDiachi = (TextBox)item.FindControl("txtDiachi");
                    if (!String.IsNullOrEmpty(txtTen.Text.Trim()))
                    {
                        HiddenField hddDuongSuID = (HiddenField)item.FindControl("hddDuongSuID");
                        CurrDS = String.IsNullOrEmpty(hddDuongSuID.Value + "") ? 0 : Convert.ToDecimal(hddDuongSuID.Value);
                        if (CurrDS > 0)
                        {
                            try
                            {
                                obj = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == CurrDS && x.VUANID == CurrVuAnID).Single<GDTTT_VUAN_DUONGSU>();
                                if (obj != null)
                                    IsUpdate = true;
                                else obj = new GDTTT_VUAN_DUONGSU();
                            }
                            catch (Exception ex) { obj = new GDTTT_VUAN_DUONGSU(); }
                        }
                        else obj = new GDTTT_VUAN_DUONGSU();
                        obj.VUANID = CurrVuAnID;
                        obj.LOAI = 2;// Convert.ToInt16(dropDSLoai.SelectedValue);
                        obj.TUCACHTOTUNG = tucachtt; //dropDuongSu.SelectedValue;
                        obj.TENDUONGSU = Cls_Comon.FormatTenRieng(txtTen.Text.Trim());
                        obj.GIOITINH = 2;
                        obj.ISINPUTADDRESS = (IsNhapDiaChi) ? 1 : 0;
                        if (IsNhapDiaChi)
                        {
                            obj.DIACHI = txtDiachi.Text.Trim();
                            DropDownList ddlTinhHuyen = (DropDownList)item.FindControl("ddlTinhHuyen");
                            obj.HUYENID = Convert.ToDecimal(ddlTinhHuyen.SelectedValue);
                            obj.DIACHI = txtDiachi.Text.Trim();
                        }
                        else
                        {
                            obj.DIACHI = "";
                            obj.HUYENID = 0;
                            obj.TINHID = 0;
                            obj.DIACHI = "";
                        }

                        if (!IsUpdate)
                        {
                            obj.NGAYTAO = DateTime.Now;
                            obj.NGUOITAO = UserName;
                            dt.GDTTT_VUAN_DUONGSU.Add(obj);
                            dt.SaveChanges();
                        }
                        else
                        {
                            obj.NGAYSUA = DateTime.Now;
                            obj.NGUOISUA = UserName;
                            dt.SaveChanges();
                        }
                    }
                    #endregion

                    //-------------------------
                    if (obj.ID > 0)
                    {
                        StrEditID += obj.ID.ToString() + ",";
                        StrUpdate += ((string.IsNullOrEmpty(StrUpdate + "")) ? "" : ", ") + Cls_Comon.FormatTenRieng(obj.TENDUONGSU);
                    }
                    count_item++;
                }
            }
            //-------------------------
            #region Update GDTTT_VUAN
            if (!String.IsNullOrEmpty(StrUpdate))
            {
                if (obj.TUCACHTOTUNG == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON)
                    objVA.NGUYENDON = StrUpdate;
                else if (obj.TUCACHTOTUNG == ENUM_DANSU_TUCACHTOTUNG.BIDON)
                    objVA.BIDON = StrUpdate;
                objVA.TENVUAN = objVA.NGUYENDON + " - " + objVA.BIDON + " - " + dropQHPL.SelectedItem.Text;
                dt.SaveChanges();
            }
            #endregion

            //--------------xoa du lieu ----------------
            List<GDTTT_VUAN_DUONGSU> lst = dt.GDTTT_VUAN_DUONGSU.Where(x => x.VUANID == CurrVuAnID
                                                                         && x.TUCACHTOTUNG == tucachtt).ToList();
            if (lst != null && lst.Count > 0)
            {
                string temp = ",";
                foreach (GDTTT_VUAN_DUONGSU ds in lst)
                {
                    temp = "," + ds.ID.ToString() + ",";
                    if (!StrEditID.Contains(temp))
                        dt.GDTTT_VUAN_DUONGSU.Remove(ds);
                }
                dt.SaveChanges();
            }
        }

        //--------------------------------------------------
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Danhsach.aspx");
        }
        void LoadDsDuongSu(Decimal CurrVuAnID, Repeater rpt, String tucachtt)
        {
            int count_all = 0, IsInputAddress = 0;
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(CurrVuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                count_all = tbl.Rows.Count;
                IsInputAddress = Convert.ToInt16(tbl.Rows[0]["IsInputAddress"] + "");
                //--------------------
                if (count_all > 0)
                {
                    switch (tucachtt)
                    {
                        case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                            Cls_Comon.SetValueComboBox(dropSoND, count_all);
                            chkND.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                            Cls_Comon.SetValueComboBox(dropSoBD, count_all);
                            chkBD.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                            Cls_Comon.SetValueComboBox(dropSoDSKhac, count_all);
                            chkDSKhac.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                    }
                    rpt.DataSource = tbl;
                    rpt.DataBind();
                }
            }
            else
            {
                //dropSoND.SelectedIndex = dropSoBD.SelectedIndex = dropSoDSKhac.SelectedIndex = 0;
                tbl = CreateTableNhapDuongSu(tucachtt);
                rpt.DataSource = tbl;
                rpt.DataBind();
            }         
        }

        DataTable CreateTableNhapDuongSu(string tucachtt)
        {
            DataTable tbl = new DataTable();
            tbl.Columns.Add("ID");
            tbl.Columns.Add("Loai", typeof(int));
            tbl.Columns.Add("TenDuongSu", typeof(string));
            tbl.Columns.Add("DiaChi", typeof(string));
            tbl.Columns.Add("HUYENID", typeof(string));
            tbl.Columns.Add("IsDelete", typeof(int));
            tbl.Columns.Add("IsInputAddress", typeof(int));
            int soluongdong = 0;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    soluongdong = Convert.ToInt16(dropSoND.SelectedValue);
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    soluongdong = Convert.ToInt16(dropSoBD.SelectedValue);
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    soluongdong = Convert.ToInt16(dropSoDSKhac.SelectedValue);
                    break;
            }
            //-----------------------
            DataRow newrow = null;
            int count_item = 1;
            int IsInputAddress = 0;
            Decimal CurrVuAnID = (String.IsNullOrEmpty(hddVuAnID.Value)) ? 0 : Convert.ToDecimal(hddVuAnID.Value + "");
            if (CurrVuAnID > 0)
            {
                GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
                DataTable tblData = objBL.GetByVuAnID(CurrVuAnID, tucachtt);
                if (tblData != null && tblData.Rows.Count > 0)
                {
                    IsInputAddress = (string.IsNullOrEmpty(tblData.Rows[0]["IsInputAddress"] + "")) ? 0 : Convert.ToInt16(tblData.Rows[0]["IsInputAddress"] + "");
                    switch (tucachtt)
                    {
                        case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                            chkND.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                            chkBD.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                        case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                            chkDSKhac.Checked = (IsInputAddress == 0) ? false : true;
                            break;
                    }

                    int count_data = tblData.Rows.Count;
                    foreach (DataRow row in tblData.Rows)
                    {
                        if (count_item <= soluongdong)
                        {
                            newrow = tbl.NewRow();
                            newrow["ID"] = row["ID"];
                            newrow["Loai"] = row["Loai"]; //ca nhan
                            newrow["TenDuongSu"] = row["TenDuongSu"];
                            newrow["DiaChi"] = row["DiaChi"];
                            newrow["HUYENID"] = row["HUYENID"] + "";
                            newrow["IsDelete"] = 1;
                            newrow["IsInputAddress"] = IsInputAddress;
                            tbl.Rows.Add(newrow);
                            count_item++;
                        }
                    }
                }
            }
            if ((count_item - 1) < soluongdong)
            {
                switch (tucachtt)
                {
                    case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                        IsInputAddress = (!chkND.Checked)  ? 0 : 1;
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                        IsInputAddress = (!chkBD.Checked) ? 0 : 1;
                        break;
                    case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                        IsInputAddress = (!chkDSKhac.Checked) ? 0 : 1;
                        break;
                }

                for (int i = count_item; i <= soluongdong; i++)
                {
                    newrow = tbl.NewRow();
                    newrow["ID"] = 0;
                    newrow["Loai"] = "0"; //ca nhan
                    newrow["TenDuongSu"] = "";
                    newrow["DiaChi"] = "";
                    newrow["HUYENID"] = 0;
                    newrow["IsDelete"] = 0;
                    newrow["IsInputAddress"] = IsInputAddress;
                    tbl.Rows.Add(newrow);
                }
            }
            return tbl;
        }
        //---------------------------
        void LoadDropSoLuong(DropDownList drop, String tucachtt)
        {
            int soluong_begin = 1;

            string str = "";
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    str = "nguyên đơn";
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    str = "bị đơn";
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    str = "người có QL&NVLQ";
                    drop.Items.Add(new ListItem("Không có ", "0"));
                    break;
            }
            for (int i = soluong_begin; i <= 50; i++)
                drop.Items.Add(new ListItem(i.ToString() + " " + str, i.ToString()));
        }
        protected void rptDuongSu_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                Cls_Comon.SetLinkButton(lkXoa, oPer.XOA);

                if (Convert.ToInt16(rowView["IsDelete"] + "") == 0)
                    lkXoa.Visible = false;
                try
                {
                    Panel pn = (Panel)e.Item.FindControl("pn");                    
                    pn.Visible = (string.IsNullOrEmpty(rowView["IsInputAddress"] + "") || Convert.ToInt16(rowView["IsInputAddress"] + "") == 0) ? false : true;

                    List<DM_HANHCHINH> lstTinhHuyen;
                    if (Session["DMTINHHUYEN"] == null)
                        lstTinhHuyen = dt.DM_HANHCHINH.OrderBy(x => x.ARRTHUTU).ToList();
                    else
                        lstTinhHuyen = (List<DM_HANHCHINH>)(Session["DMTINHHUYEN"]);
                    DropDownList ddlTinhHuyen = (DropDownList)e.Item.FindControl("ddlTinhHuyen");
                    ddlTinhHuyen.DataSource = lstTinhHuyen;
                    ddlTinhHuyen.DataTextField = "MA_TEN";
                    ddlTinhHuyen.DataValueField = "ID";
                    ddlTinhHuyen.DataBind();
                    ddlTinhHuyen.Items.Insert(0, new ListItem("Tỉnh/Huyện", "0"));
                    if (pn.Visible)
                    {
                        HiddenField hddHuyenID = (HiddenField)e.Item.FindControl("hddHuyenID");
                        string strHID = hddHuyenID.Value + "";
                        if (strHID != "")
                            ddlTinhHuyen.SelectedValue = strHID;
                    }
                }
                catch (Exception ex) { }
            }
        }
        protected void rptNguyenDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_id, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    break;
            }
        }

        protected void rptBiDon_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_id, ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    break;
            }
        }

        protected void rptDsKhac_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa_DS(curr_id, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    break;
            }
        }

        void Xoa_DS(decimal currrid, string tucachtt)
        {
            GDTTT_VUAN_DUONGSU oT = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == currrid).FirstOrDefault();
            dt.GDTTT_VUAN_DUONGSU.Remove(oT);
            dt.SaveChanges();

            //-------------------------------
            int sodong = 0;
            DataTable tbl = null;
            switch (tucachtt)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    sodong = Convert.ToInt16(dropSoND.SelectedValue) - 1;
                    dropSoND.SelectedValue = ((sodong == 0) ? 1 : sodong).ToString();
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
                    rptNguyenDon.DataSource = tbl;
                    rptNguyenDon.DataBind();
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    sodong = Convert.ToInt16(dropSoBD.SelectedValue) - 1;
                    dropSoBD.SelectedValue = ((sodong == 0) ? 1 : sodong).ToString();
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
                    rptBiDon.DataSource = tbl;
                    rptBiDon.DataBind();
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    sodong = Convert.ToInt16(dropSoDSKhac.SelectedValue) - 1;
                    dropSoDSKhac.SelectedValue = ((sodong == 0) ? 1 : sodong).ToString();
                    tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
                    rptDsKhac.DataSource = tbl;
                    rptDsKhac.DataBind();
                    break;
            }
            lttMsg.Text = lttMsgT.Text = "Xóa thành công!";
        }


        protected void dropSoND_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            rptNguyenDon.DataSource = tbl;
            rptNguyenDon.DataBind();
            Cls_Comon.SetFocus(this, this.GetType(), dropSoND.ClientID);
        }
        protected void chkND_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptNguyenDon.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkND.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }
        protected void lkThemND_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            //--------------------------------
            GDTTT_VUAN obj = Save_VuAn();
            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, rptNguyenDon);

            int old = Convert.ToInt32(dropSoND.SelectedValue);
            dropSoND.SelectedValue = (old + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.NGUYENDON);
            rptNguyenDon.DataSource = tbl;
            rptNguyenDon.DataBind();
        }
        //--------------------------
        protected void dropSoBD_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            rptBiDon.DataSource = tbl;
            rptBiDon.DataBind();
            Cls_Comon.SetFocus(this, this.GetType(), dropSoBD.ClientID);
        }
        protected void chkBD_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptBiDon.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkBD.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }
        protected void lkThemBD_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            //--------------------------------
            GDTTT_VUAN obj = Save_VuAn();
            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.BIDON, rptBiDon);

            int old = Convert.ToInt32(dropSoBD.SelectedValue);
            dropSoBD.SelectedValue = (old + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.BIDON);
            rptBiDon.DataSource = tbl;
            rptBiDon.DataBind();
        }
        //---------------------------

        protected void dropSoDSKhac_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            rptDsKhac.DataSource = tbl;
            rptDsKhac.DataBind();
            Cls_Comon.SetFocus(this, this.GetType(), dropSoDSKhac.ClientID);
        }
        protected void chkDSKhac_CheckedChanged(object sender, EventArgs e)
        {
            foreach (RepeaterItem item in rptDsKhac.Items)
            {
                Panel pn = (Panel)item.FindControl("pn");
                if (chkDSKhac.Checked && pn != null)
                    pn.Visible = true;
                else pn.Visible = false;
            }
        }
        protected void lkThemDSKhac_Click(object sender, EventArgs e)
        {
            String msg_check = CheckNhapDuongSu_TheoLoai(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            if (!String.IsNullOrEmpty(msg_check))
            {
                lttMsg.Text = lttMsgT.Text = msg_check;
                return;
            }
            //--------------------------------
            GDTTT_VUAN obj = Save_VuAn();
            //Update duong su
            Update_DuongSu(obj, ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ, rptDsKhac);

            int old = Convert.ToInt32(dropSoDSKhac.SelectedValue);
            dropSoDSKhac.SelectedValue = (old + 1).ToString();
            DataTable tbl = CreateTableNhapDuongSu(ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ);
            rptDsKhac.DataSource = tbl;
            rptDsKhac.DataBind();
        }
        //------------------------------
        string CheckNhapDuongSu_TheoLoai(string loai_ds)
        {
            String StrNguyenDon = "", StrBiDon = "";
            int count_item = 0;
            switch (loai_ds)
            {
                case ENUM_DANSU_TUCACHTOTUNG.NGUYENDON:
                    foreach (RepeaterItem item in rptNguyenDon.Items)
                    {
                        count_item++;
                        TextBox txtTen = (TextBox)item.FindControl("txtTen");
                        if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                            StrNguyenDon += (String.IsNullOrEmpty(StrNguyenDon) ? "" : ", ") + count_item.ToString();
                    }
                    if (!String.IsNullOrEmpty(StrNguyenDon))
                        StrNguyenDon = "nguyên đơn thứ " + StrNguyenDon;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.BIDON:
                    foreach (RepeaterItem item in rptBiDon.Items)
                    {
                        count_item++;
                        TextBox txtTen = (TextBox)item.FindControl("txtTen");
                        if (String.IsNullOrEmpty(txtTen.Text.Trim()))
                            StrBiDon += (String.IsNullOrEmpty(StrBiDon) ? "" : ", ") + count_item.ToString();
                    }
                    if (!String.IsNullOrEmpty(StrBiDon))
                        StrBiDon = "bị đơn  thứ " + StrBiDon;
                    break;
                case ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ:
                    break;
            }
            //------------------------------
            String msg = "";
            if ((!String.IsNullOrEmpty(StrNguyenDon)) || (!String.IsNullOrEmpty(StrBiDon)))
            {
                msg = "Lưu ý: " + StrNguyenDon
                    + (string.IsNullOrEmpty(StrNguyenDon) ? "" : ";")
                    + StrBiDon + " chưa được nhập. Hãy kiểm tra lại!";
            }
            return msg;
        }
        //---------------------------
        protected void lkTTV_Click(object sender, EventArgs e)
        {
            if (pnTTV.Visible == false)
            {
                lkTTV.Text = "[ Thu gọn ]";
                pnTTV.Visible = true;
                Session[SessionTTV] = "0";
            }
            else
            {
                lkTTV.Text = "[ Mở ]";
                pnTTV.Visible = false;
                Session[SessionTTV] = "1";
            }
        }
       
    }
}