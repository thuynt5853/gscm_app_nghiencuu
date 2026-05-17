using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using Module.Common;
using System;
using System.Text;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class QLHoso : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal VuAnID = 0, NguoiTGTTID = 0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        Decimal CurrentUserID = 0;
        Decimal PhongBanID = 0, CurrDonViID = 0;
        String SessionName = "GDTTT_ReportPL".ToUpper();
        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            CurrentYear = DateTime.Now.Year;
            VuAnID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");

            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    txtNgayTao.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    GetNewSoPhieu();

                    if (VuAnID > 0)
                    {
                        try {
                            LoadDropToaAn_VKS();
                            LoadDropCanBo();
                            LoadDropNguoiKy();
                            LoadThongTinVuAn(VuAnID);
                        
                            LoadDsHoSo();
                        } catch(Exception exx) {  }
                    }
                    else
                        pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = cmdPrinDS.Enabled = false;
                }
            }
        }
       
        void LoadThongTinVuAn(Decimal VuAnID)
        {
            GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                if (!String.IsNullOrEmpty(oT.TENVUAN + ""))
                    txtTenVuan.Text = oT.TENVUAN;
                else
                {
                    txtTenVuan.Text = oT.NGUYENDON + " - " + oT.BIDON;
                    if (oT.QHPL_DINHNGHIAID != null && oT.QHPL_DINHNGHIAID > 0)
                    {
                        GDTTT_DM_QHPL oQHPL = dt.GDTTT_DM_QHPL.Where(x => x.ID == oT.QHPL_DINHNGHIAID).FirstOrDefault();
                        txtTenVuan.Text = txtTenVuan.Text + " - " + oQHPL.TENQHPL;
                    }
                }
                //------------------------
                txtVuAn_SoThuLy.Text = oT.SOTHULYDON;
                txtVuAn_NgayThuLy.Text = (String.IsNullOrEmpty(oT.NGAYTHULYDON + "") || (oT.NGAYTHULYDON == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYTHULYDON).ToString("dd/MM/yyyy", cul);

                if (oT.BAQD_CAPXETXU == 4)
                {
                    txtVuAn_SoBanAn.Text = oT.SO_QDGDT;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYQD + "") || (oT.NGAYQD == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYQD).ToString("dd/MM/yyyy", cul);

                    hddVuAn_ToaAnID.Value = oT.TOAQDID + "";
                }
                else if (oT.BAQD_CAPXETXU == 2)
                {
                    txtVuAn_SoBanAn.Text = oT.SOANSOTHAM;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUSOTHAM + "") || (oT.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul);

                    hddVuAn_ToaAnID.Value = oT.TOAANSOTHAM + "";
                }
                else
                {
                    txtVuAn_SoBanAn.Text = oT.SOANPHUCTHAM;
                    txtVuAn_NgayBanAn.Text = (String.IsNullOrEmpty(oT.NGAYXUPHUCTHAM + "") || (oT.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul);

                    hddVuAn_ToaAnID.Value = oT.TOAPHUCTHAMID + "";
                }

                if (oT.LOAIAN == 1)
                {
                    pnBicaoDv.Visible = pnBicaoKN.Visible = true;
                    pnNguyendo.Visible = pnBidon.Visible = false;
                    txtVuAn_NguyenDon.Text = oT.NGUYENDON;
                    txtVuAn_BiDon.Text = oT.BIDON;
                }
                else
                {
                    pnBicaoDv.Visible = pnBicaoKN.Visible = false;
                    pnNguyendo.Visible = pnBidon.Visible = true;
                    //----------------------------------
                    LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.NGUYENDON, txtVuAn_NguyenDon);
                    LoadDuongSu(VuAnID, ENUM_DANSU_TUCACHTOTUNG.BIDON, txtVuAn_BiDon);
                }
                
                //------------------------
                if (!string.IsNullOrEmpty(oT.THAMTRAVIENID + "") && oT.THAMTRAVIENID > 0)
                {
                    Cls_Comon.SetValueComboBox(dropCanBo, oT.THAMTRAVIENID);
                    lblHoTen.Visible = txtCanBo.Visible = lttValidHoTen.Visible = false;
                }
            }
        }
        void LoadDuongSu(Decimal VuAnID,string tucachtt, Literal control_display)
        {
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.GetByVuAnID(VuAnID, tucachtt);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach(DataRow row in tbl.Rows)
                {
                    if (!String.IsNullOrEmpty(StrDisplay + ""))
                        StrDisplay += ", " + row["TenDuongSu"].ToString();
                    else
                        StrDisplay = row["TenDuongSu"].ToString();
                }
            }
            control_display.Text = StrDisplay;
        }
        void LoadDropCanBo()
        {
            dropCanBo.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tbl = obj.DM_CANBO_GetByPhongBan(PhongBanID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropCanBo.DataSource = tbl;
                dropCanBo.DataValueField = "CanBoID";
                dropCanBo.DataTextField = "HoTen";
                dropCanBo.DataBind();
                dropCanBo.Items.Insert(0, new ListItem("Không chọn", "0"));
            }
            else
                dropCanBo.Items.Insert(0, new ListItem("Không chọn", "0"));
        }
        void LoadDropNguoiKy()
        {
            dropNguoiKy.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tbl = obj.DM_CANBO_GetByPhongBan(PhongBanID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataView dv = tbl.DefaultView;
                dv.RowFilter = "CHUCVUID IN (424, 432)";

                dropNguoiKy.DataSource = dv;
                dropNguoiKy.DataValueField = "CanBoID";
                dropNguoiKy.DataTextField = "HoTen";
                dropNguoiKy.DataBind();
                dropNguoiKy.Items.Insert(0, new ListItem("---Chọn---", "0"));
            }
            else
            {
                dropNguoiKy.Items.Insert(0, new ListItem("---Chọn---", "0"));
            }
        }
        void LoadDropToaAn_VKS()
        {
            dropToaAn_VKS.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            if (rdLoaiDV.SelectedValue == "0")
            {
                DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
                dropToaAn_VKS.DataSource = dtTA;
                dropToaAn_VKS.DataTextField = "MA_TEN";
                dropToaAn_VKS.DataValueField = "ID";
                dropToaAn_VKS.DataBind();
                //dropToaAn_VKS.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
            {
                //load ds VKS
                List<DM_VKS> lst = dt.DM_VKS.OrderBy(x => x.ARRTHUTU).ToList();
                dropToaAn_VKS.DataSource = lst;
                dropToaAn_VKS.DataTextField = "MA_TEN";
                dropToaAn_VKS.DataValueField = "ID";
                dropToaAn_VKS.DataBind();
                //dropToaAn_VKS.Items.Insert(0, new ListItem("Chọn", "0"));
            }
        }
        public void LoadInfo()
        {
            lbthongbao.Text = "";
            decimal ID = Convert.ToDecimal(hddCurrID.Value);
            decimal VuAn_ToaAnID = Convert.ToDecimal(hddVuAn_ToaAnID.Value);
            
            try
            {
                GDTTT_QUANLYHS obj = dt.GDTTT_QUANLYHS.Where(x => x.ID == ID).FirstOrDefault();
                if (obj != null)
                {
                    Decimal tempID = 0;
                    tempID = String.IsNullOrEmpty(obj.LOAI + "") ? 0 : Convert.ToDecimal(obj.LOAI);
                    Cls_Comon.SetValueComboBox(dropLoai, tempID);
                    cmdPrinBM.Visible = (tempID == 0) ? true : false;
                    
                    //---------------------------
                    tempID = String.IsNullOrEmpty(obj.ISMUONHOSOVKS + "") ? 0 : Convert.ToDecimal(obj.ISMUONHOSOVKS);
                    rdLoaiDV.SelectedValue = tempID.ToString();
                    //if (rdLoaiDV.SelectedValue == "0")
                    //    lblDonVi.Text = "Tòa án";
                    //else lblDonVi.Text = "Viện kiểm sát";
                    if (tempID != 2)
                    {
                        txtToaAn_VKS.Visible = false;                        
                        txtToaAn_VKS.Text = "";
                        dropToaAn_VKS.Visible = true;
                        LoadDropToaAn_VKS();
                        if (tempID == 0)
                        {
                            //Load thong tin toa an nhan phieu muon HS (chinh la toa xu vu an (neu ko luu))
                            tempID = String.IsNullOrEmpty(obj.TOAANMUONHSID + "") ? 0 : Convert.ToDecimal(obj.TOAANMUONHSID);
                            if (tempID > 0)
                                Cls_Comon.SetValueComboBox(dropToaAn_VKS, tempID);
                            else
                                Cls_Comon.SetValueComboBox(dropToaAn_VKS, VuAn_ToaAnID);
                        }
                        else
                        {
                            //Muon HS tu VKS
                            tempID = String.IsNullOrEmpty(obj.VKSMUONHSID + "") ? 0 : Convert.ToDecimal(obj.VKSMUONHSID);
                            if (tempID > 0)
                                Cls_Comon.SetValueComboBox(dropToaAn_VKS, tempID);
                        }
                    }
                    else
                    {
                        dropToaAn_VKS.Visible = false;
                        dropToaAn_VKS.SelectedIndex = 0;
                        txtToaAn_VKS.Visible = true;
                        txtToaAn_VKS.Text = obj.TENDONVIMUONHS + "";
                    }
                    //---------------------------                    
                    tempID = String.IsNullOrEmpty(obj.CANBOID + "") ? 0 : (decimal)obj.CANBOID;
                    Cls_Comon.SetValueComboBox(dropCanBo, tempID);
                    if (tempID > 0)
                    {
                        lblHoTen.Visible = txtCanBo.Visible = lttValidHoTen.Visible = false;     
                    }
                    else
                    {
                        lblHoTen.Visible = txtCanBo.Visible = lttValidHoTen.Visible = true;
                    }
                    txtCanBo.Text = obj.TENCANBO;
                    //------------------
                    var NGUOIKYID = String.IsNullOrEmpty(obj.NGUOIKYID + "") ? 0 : (decimal)obj.NGUOIKYID;
                    Cls_Comon.SetValueComboBox(dropNguoiKy, NGUOIKYID);
                    txtNgayTao.Text = (String.IsNullOrEmpty(obj.NGAYTAO + "") || (obj.NGAYTAO == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTAO).ToString("dd/MM/yyyy", cul);
                    txtSoPhieu.Text = obj.SOPHIEU + "";
                    txtGhiChu.Text = obj.GHICHU + "";
                }
            }
            catch(Exception ex) { }
        }
        public void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ClearForm();
        }
        protected void cmdUpdateAndNext_Click(object sender, EventArgs e)
        {
            try
            {
                SaveData();
                //--------------------
                ClearForm();
                //---------------------
                hddPageIndex.Value = "1";
                LoadDsHoSo();
                //----------------
                lbthongbao.Text = "Cập nhật thành công!";
                hddIsReloadParent.Value = "1";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }
       
        void SaveData()
        {
            lbl_SoPhieu.Text = "";
            if (dropLoai.SelectedIndex == 0)
            {
                if (dropNguoiKy.SelectedIndex == null || dropNguoiKy.SelectedIndex == 0)
                {
                    lbl_NguoiKy.Text = "(*)";
                }
            }
            /*Lưu ý: Vu an duoc coi la co ho so khi da co phieu nhan.*/
            GDTTT_QUANLYHS obj = new GDTTT_QUANLYHS();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrDonID = (String.IsNullOrEmpty(hddCurrID.Value)) ? 0 : Convert.ToDecimal(hddCurrID.Value + "");

            if (CurrDonID > 0)
            {
                try
                {
                    obj = dt.GDTTT_QUANLYHS.Where(x => x.ID == CurrDonID).Single<GDTTT_QUANLYHS>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_QUANLYHS();
                }
                catch (Exception ex) { obj = new GDTTT_QUANLYHS(); }
            }
            else
                obj = new GDTTT_QUANLYHS();

            obj.LOAI = dropLoai.SelectedValue;
            obj.VUANID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");

            //------------------------------
            obj.TOAANMUONHSID = obj.VKSMUONHSID = 0;
            obj.ISMUONHOSOVKS = Convert.ToDecimal(rdLoaiDV.SelectedValue);
            obj.TOAANMUONHSID = obj.VKSMUONHSID = 0;
            obj.TENDONVIMUONHS = "";
            switch ((int)obj.ISMUONHOSOVKS)
            {
                case 0:
                    obj.TOAANMUONHSID = Convert.ToDecimal(dropToaAn_VKS.SelectedValue);
                    break;
                case 1:
                    obj.VKSMUONHSID = Convert.ToDecimal(dropToaAn_VKS.SelectedValue);
                    break;
                case 2:
                    obj.TENDONVIMUONHS= txtToaAn_VKS.Text;
                    break;
            }
            //if (dropLoai.SelectedValue == "3" && Session[ENUM_SESSION.SESSION_PHONGBANID] + "" == "3")//vụ 2
            //{
            //    obj.TOAANMUONHSID = obj.VKSMUONHSID = 0;
            //}
            //------------------------------
            if (dropCanBo.SelectedValue == "0")
            {
                obj.CANBOID = 0;
                obj.TENCANBO = Cls_Comon.FormatTenRieng(txtCanBo.Text.Trim());
            }
            else
            {
                obj.CANBOID = Convert.ToDecimal(dropCanBo.SelectedValue);
                obj.TENCANBO = dropCanBo.SelectedItem.Text;
            }
            if (dropNguoiKy.SelectedValue != null && dropNguoiKy.SelectedValue != "0")
            {
                obj.NGUOIKYID = Convert.ToDecimal(dropNguoiKy.SelectedValue);
                var OCanBo = DataExtensions.FindById<DM_CANBO>(obj.NGUOIKYID.Value);
                if (OCanBo != null) { obj.CHUCVUID = OCanBo.CHUCVUID; }
            }
            //------------------------------
            DateTime date_temp = (String.IsNullOrEmpty(txtNgayTao.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayTao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYTAO = date_temp;
            if (txtSoPhieu.Text != "")
            {
                obj.SOPHIEU = Convert.ToDecimal(txtSoPhieu.Text.Trim());
            }
            obj.GHICHU = txtGhiChu.Text;
            if (!IsUpdate)
            {
                obj.TRANGTHAI = Convert.ToInt16(obj.LOAI);
                obj.GROUPID = Guid.Empty.ToString(); //Guid.NewGuid().ToString();               
                dt.GDTTT_QUANLYHS.Add(obj);
            }

            dt.SaveChanges();
            hddCurrID.Value = obj.ID.ToString();
            //---------------------------------
            Update_TTHoSoVuAn();
            try
            {
                List<GDTTT_QUANLYHS> lst = null;
                GDTTT_QUANLYHS objhosotemp = null;
                switch (obj.LOAI)
                {
                    case "3":
                        //Nhan ho so
                         lst = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == (Decimal)obj.VUANID
                                                        && x.CANBOID == obj.CANBOID
                                                        && x.LOAI != "4"
                                                        && x.NGAYNHAN == null
                                                     ).OrderByDescending(x => x.NGAYTAO).ToList();
                        if (lst != null && lst.Count() > 0)
                        {
                            objhosotemp = lst[0];
                            objhosotemp.NGAYNHAN = obj.NGAYTAO;
                            //0: muon hs /1:Tra hs /2:chuyen hs /3: nhan hs
                            objhosotemp.TRANGTHAI = 3;
                            dt.SaveChanges();
                            GDTTT_VUAN obj_vuan = new GDTTT_VUAN();
                            obj_vuan = dt.GDTTT_VUAN.Where(x => x.ID == (Decimal)obj.VUANID).Single();
                            obj_vuan.HOSOID = objhosotemp.ID;
                            dt.SaveChanges();
                        }
                        break;
                    //---------------------------------
                    case "2":
                        //tra ho so
                        lst = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == (Decimal)obj.VUANID
                                                        && x.CANBOID == obj.CANBOID
                                                        && x.LOAI != "4"
                                                        && x.NGAYTRA == null
                                                     ).OrderByDescending(x => x.NGAYTAO).ToList();
                        if (lst != null && lst.Count() > 0)
                        {
                            objhosotemp = lst[0];
                            objhosotemp.NGAYTRA = obj.NGAYTAO;
                            //0: muon hs /1:Tra hs /2:chuyen hs /3: nhan hs
                            objhosotemp.TRANGTHAI = 1;
                            dt.SaveChanges();
                        }
                        break;
                }
            }catch(Exception e) { }
        }
        void ClearForm()
        {
            dropLoai.SelectedIndex  = dropCanBo.SelectedIndex= 0;
            rdLoaiDV.SelectedValue = "0";

            lblHoTen.Visible = txtCanBo.Visible = lttValidHoTen.Visible = true;
            txtCanBo.Text = "";
            hddCurrID.Value = "0";
            lbthongbao.Text = "";
            txtNgayTao.Text = DateTime.Now.ToString("dd/MM/yyyy");
            if (dropLoai.SelectedValue != "3")
            {
                GetNewSoPhieu();
            }
            txtGhiChu.Text = "";
            txtToaAn_VKS.Text = "";
            txtToaAn_VKS.Visible = false;
        }
        //---------------------------------------
        #region Load ds
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDsHoSo();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadDsHoSo()
        {
            String textsearch = txtTextSearch.Text.Trim();
            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            GDTTT_QUANLYHS_BL objBL = new GDTTT_QUANLYHS_BL();
            DataTable tbl = objBL.GetAllPaging(VuAnID,  pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                 lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = cmdPrinDS.Visible = true;
            }
            else
                pnPagingBottom.Visible = pnPagingTop.Visible = rpt.Visible = cmdPrinDS.Visible = false;
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = 0;
            switch (e.CommandName)
            {
                case "Print":
                    String SessionName = "GDTTT_ReportPL".ToUpper();
                    Session[SessionName] = null;
                    Session[SS_TK.TENBAOCAO] = "In phiếu";
                    try
                    {
                        string [] para = e.CommandArgument.ToString().Split(',');
                        int loai_phieu =Convert.ToInt32(para[1] + "");
                        curr_id = Convert.ToDecimal(para[0]);
                        GDTTT_QUANLYHS objhs = dt.GDTTT_QUANLYHS.Where(x => x.ID == curr_id).Single();
                        string loaitoa = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                        // GTEL-DUCPH 20-09-2025 14h lấy thêm cấp xét xử để xử lý cho Tỉnh giống Cấp Cao
                        string capXetXu = Session["CAP_XET_XU"].ToString(); 
                        if (loaitoa.Contains("cấp cao") || capXetXu == "CAPTINH") {  //bắt được bệnh chô này thêm loại tòa cấp tỉnh nữa là done
                            LoadReportHS(curr_id);
                        }
                        else
                        {
                            if (loai_phieu == 0)
                            {
                                if (objhs.GROUPID != Guid.Empty.ToString())
                                    Cls_Comon.CallFunctionJS(this, this.GetType(), "Print('" + objhs.GROUPID + "',1)");
                                else
                                    Cls_Comon.CallFunctionJS(this, this.GetType(), "Print(" + curr_id + ",0)");
                            }
                        }

                        //---------------------
                    }catch(Exception ex) { }
                    break;
                case "Sua":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    hddCurrID.Value = curr_id.ToString();
                    LoadInfo();
                    break;
                case "Xoa":
                    curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
                    xoa(curr_id);
                    break;
            }
        }
        void Update_TTHoSoVuAn()
        {
            Decimal VuAnID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            string phieu_nhan = "3";
            GDTTT_VUAN objVA = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).Single();
            try
            {
                decimal VuAn_HoSoNhanID = (string.IsNullOrEmpty(objVA.HOSOID + "")) ? 0 : (decimal)objVA.HOSOID;
                List<GDTTT_QUANLYHS> lst = dt.GDTTT_QUANLYHS.Where(x => x.VUANID == VuAnID
                                                                       && x.LOAI == phieu_nhan).ToList();
                if (lst != null && lst.Count > 0)
                    objVA.ISHOSO = 1;
                else objVA.ISHOSO = 0;
            }
            catch(Exception ex) { objVA.ISHOSO = 0; }
            dt.SaveChanges();
        }
        void xoa(decimal id)
        {
            GDTTT_QUANLYHS oND = dt.GDTTT_QUANLYHS.Where(x => x.ID == id).FirstOrDefault();
            if (oND != null)
            {
                decimal loai = Convert.ToDecimal(oND.LOAI);
                
                dt.GDTTT_QUANLYHS.Remove(oND);
                dt.SaveChanges();

                decimal phieu_nhan = 3;
                try
                {
                    if (loai == phieu_nhan)
                        Update_TTHoSoVuAn();
                }
                catch (Exception ex) { }

                hddIsReloadParent.Value = "1";
                hddPageIndex.Value = "1";

                LoadDsHoSo();
                lbthongbao.Text = "Xóa thành công!";
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
        }
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadDsHoSo();
            }
            catch (Exception ex) { }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDsHoSo();
            }
            catch (Exception ex) { }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDsHoSo();
            }
            catch (Exception ex) { }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDsHoSo();
            }
            catch (Exception ex) { }
        }
        protected void dropLoai_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropLoai.SelectedValue == "0")
                cmdPrinBM.Visible = true;
            else cmdPrinBM.Visible = false;
            hddCurrID.Value = "0";

            if (dropLoai.SelectedValue == "3")
            {
                //if (Session[ENUM_SESSION.SESSION_PHONGBANID]+"" == "3")//vụ 2
                //{
                //    donvi_hs.Style.Add("Display", "none");
                //}
                txtSoPhieu.Text = "";
                lbl_SoPhieu.Text = "";
                lblNgayTH.Text = "Ngày nhận";
            }
            else
            {
                //donvi_hs.Style.Remove("Display");
                lblNgayTH.Text = "Ngày lập phiếu";
                lbl_SoPhieu.Text = "(*)";
                GetNewSoPhieu();
            }
        }
        protected void dropCanBo_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropCanBo.SelectedValue == "0")
                lblHoTen.Visible = txtCanBo.Visible= lttValidHoTen.Visible = true;            
            else
                lblHoTen.Visible = txtCanBo.Visible = lttValidHoTen.Visible = false;
        }
        

        protected void cmdPrinBM_Click(object sender, EventArgs e)
        {
            String SessionName = "GDTTT_ReportPL".ToUpper();
            Session[SessionName] = null;
            Session[SS_TK.TENBAOCAO] = "In " + dropLoai.SelectedItem.Text;

            Decimal CurrentID = 0;
            try
            {
                SaveData();
                CurrentID = Convert.ToDecimal(hddCurrID.Value);
                String JS = "window.open('/QLAN/GDTTT/VuAn/BaoCao/ViewBC.aspx?type=hoso&loai=bm&vID=" + Request["vID"]
                    +"&hsID=" + CurrentID + "'"
                    + ", '', 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=950, height=500, top=100, left=10')";
               
                Cls_Comon.CallFunctionJS(this, this.GetType(), JS);
                //---------------------
                hddPageIndex.Value = "1";
                LoadDsHoSo();
                //----------------
                lbthongbao.Text = "Cập nhật thành công!";
                hddIsReloadParent.Value = "1";
                ClearForm();
            }
            catch (Exception exx) { }
        }
        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            String textsearch = txtTextSearch.Text.Trim();
            int page_size = 2000000000;
            String SessionName = "GDTTT_ReportPL".ToUpper();
            Session[SS_TK.TENBAOCAO] = "Quản lý hồ sơ";

            GDTTT_QUANLYHS_BL objBL = new GDTTT_QUANLYHS_BL();            
            DataTable tblData =  objBL.GetAllPaging(VuAnID,  1, page_size);
            if (tblData != null && tblData.Rows.Count > 0)
                Session[SessionName] = tblData;
        }
        
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDsHoSo();
            }
            catch (Exception ex) { }
        }
        #endregion
        protected void txtNgayTao_TextChanged(object sender, EventArgs e)
        {
            GetNewSoPhieu();
        }
        void GetNewSoPhieu()
        {
            Decimal loaiphieu =Convert.ToDecimal( dropLoai.SelectedValue);
            DateTime NgayTao =(DateTime)((String.IsNullOrEmpty(txtNgayTao.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtNgayTao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));
            GDTTT_VUAN_BL objBL = new GDTTT_VUAN_BL();
            Decimal SoCV = objBL.GetLastSoPhieuHS(loaiphieu, NgayTao, CurrDonViID, PhongBanID);
            txtSoPhieu.Text = SoCV +"";
        }
        //-------------------------
        protected void rdLoaiDV_SelectedIndexChanged(object sender, EventArgs e)
        {
            string loai = rdLoaiDV.SelectedValue;
            //if (loai == "0")
            //    lblDonVi.Text = "Tòa án";
            //else lblDonVi.Text = "Viện kiểm sát";
            if (loai == "2")
            {
                txtToaAn_VKS.Visible = true;
                dropToaAn_VKS.Visible = false;
                dropToaAn_VKS.SelectedIndex = 0;
            }
            else
            {
                txtToaAn_VKS.Visible = false;
                txtToaAn_VKS.Text = "";
                dropToaAn_VKS.Visible = true;
                LoadDropToaAn_VKS();
            }           
        }
        private void LoadReportHS(decimal phieu_id)
        {
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();

            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = oBL.GDTTT_HOSO_INPHIEU(CurrDonViID, phieu_id);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //-------------------Export---------------------------
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=Phieu_Muon_Ho_So.doc");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.ContentType = "application/msword";
            HttpContext.Current.Response.ContentEncoding = System.Text.UnicodeEncoding.UTF8;
            Response.Write("<html");
            Response.Write("<head>");
            Response.Write("<!--[if gte mso 9]> <xml> <w:WordDocument> <w:View>Print</w:View> <w:Zoom>100</w:Zoom> <w:DoNotOptimizeForBrowser/> </w:WordDocument> </xml> <![endif]-->");
            Response.Write("<META HTTP-EQUIV=Content-Type CONTENT=text/html; charset=UTF-8>");
            Response.Write("<meta name=ProgId content=Word.Document>");
            Response.Write("<meta name=Generator content=Microsoft Word 9>");
            Response.Write("<meta name=Originator content=Microsoft Word 9>");
            Response.Write("<style>");
            Response.Write("<!-- /* Style Definitions */" +
                                          "p.MsoFooter, li.MsoFooter, div.MsoFooter" +
                                          "{margin:0in;" +
                                          "margin-bottom:.0001pt;" +
                                          "mso-pagination:widow-orphan;" +
                                          "tab-stops:center 3.0in right 6.0in;" +
                                          "font-size:12.0pt;}");
            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.78740196228in 0.78740196228in 0.78740196228in 1.181in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section1 {page:Section1;}");
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5905511811in 0.2992125984in 0.5905511811in 0.5984251969in;mso-header: h1;mso-header-margin:.2in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            Response.Write("div.Section2 {page:Section2;}");
            Response.Write("<style>");
            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section1>");//chỉ định khổ giấy
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("</div>");
            Response.Write("</body>");
            Response.Write("</html>");
            Response.End();
        }
        
    }
}