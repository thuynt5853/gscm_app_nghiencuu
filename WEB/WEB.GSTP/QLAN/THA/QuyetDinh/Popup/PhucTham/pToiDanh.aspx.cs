using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHS;
using BL.GSTP.BANGSETGET;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP.THA;
using BL.GSTP.BANGSETGET.THA;

namespace WEB.GSTP.QLAN.THA.QuyetDinh.Popup.PhucTham
{
    public partial class pToiDanh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        public Decimal BiCanID = 0, BanAnID = 0, VuAnID = 0;
        public decimal NhomHinhPhatBS = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
             ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            if (Session[ENUM_LOAIAN.AN_THA] != null)
            {
                BiCanID = (String.IsNullOrEmpty(Request["aID"] + "")) ? 0 : Convert.ToDecimal(Request["aID"] + "");
                VuAnID = (decimal)dt.THA_BIAN.Where(x => x.ID == BiCanID).FirstOrDefault()?.VUANID;

                NhomHinhPhatBS = dt.DM_DATAITEM.Where(x => x.MA == ENUM_NHOMHINHPHAT.NHOM_HPBOSUNG).SingleOrDefault().ID;
                
                if (!IsPostBack)
                {
                    CheckQuyenSuaXoa();
                    LoadDrop();
                    LoadDsToiDanhByBiCan();
                }
            } 
            else
                Response.Redirect("/Login.aspx");
        }

        bool CheckQuyenSuaXoa()
        {
            decimal BiAnID = BiCanID;
            decimal VuAnXLId = VuAnID;

            THA_CVDON_THULY cvd_tl = dt.THA_CVDON_THULY.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnXLId)
                .FirstOrDefault();
            if (cvd_tl != null)
            {
                lbthongbao.Text = "Đã có 4.1.Thụ lý công văn/đơn. Không được thay đổi thông tin!";
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                Cls_Comon.SetButton(cmdChonDieuLuat, false);
                return false;
            }

            THA_UYTHAC_QUYETDINH qduttha = dt.THA_UYTHAC_QUYETDINH.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnXLId)
                .FirstOrDefault();
            if (qduttha != null)
            {
                lbthongbao.Text =
                    "Đã có 5.1.Quyết định ủy thác thi hành án. Không được thay đổi thông tin!";
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                Cls_Comon.SetButton(cmdChonDieuLuat, false);
                return false;
            }

            THA_CACQDKHAC qdk = dt.THA_CACQDKHAC.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnXLId).FirstOrDefault();
            if (qdk != null)
            {
                lbthongbao.Text = "Đã có 6.Các quyết định khác. Không được thay đổi thông tin!";
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                Cls_Comon.SetButton(cmdChonDieuLuat, false);
                return false;
            }

            THA_ANTICH_DON xattld = dt.THA_ANTICH_DON.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnXLId)
                .FirstOrDefault();
            if (xattld != null)
            {
                lbthongbao.Text = "Đã có 7.1.Thụ lý đơn. Không được thay đổi thông tin!";
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                Cls_Comon.SetButton(cmdChonDieuLuat, false);
                return false;
            }

            THA_DACXA dxtld = dt.THA_DACXA.Where(x => x.BIANID == BiAnID && x.VUANID == VuAnXLId).FirstOrDefault();
            if (dxtld != null)
            {
                lbthongbao.Text = "Đã có 8.Thụ lý đơn. Không được thay đổi thông tin!";
                Cls_Comon.SetButton(cmdThemDieuLuat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat, false);
                Cls_Comon.SetButton(cmdSaveHinhPhat2, false);
                Cls_Comon.SetButton(cmdChonDieuLuat, false);
                return false;
            }

            return true;
        }

        //su kien xay ra sau khi thuc hien xong sk gay postback
        protected void Page_PreRender(object sender, EventArgs e)
        {
            Decimal row_hinhphat = 0;
            //------------------------
            Decimal CurrToiDanhId = (string.IsNullOrEmpty(hddCurrToiDanhID.Value)) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);
            foreach (RepeaterItem item in rpt.Items)
            {
                HiddenField hddToiDanh = (HiddenField)item.FindControl("hddToiDanh");
                LinkButton lk = (LinkButton)item.FindControl("lk");
                Image Image = (Image)item.FindControl("Image");
                if (CurrToiDanhId == Convert.ToDecimal(hddToiDanh.Value))
                {
                    lk.Visible = false;
                    Image.Visible = true;
                    Image.ImageUrl = "../../../../../UI/img/check.png";
                    Cls_Comon.SetFocus(this, this.GetType(), cmdSaveHinhPhat.ClientID);
                }
                else
                {
                    Image.Visible = false;
                    lk.Visible = true;
                }
            }
            //-------------------------------
            decimal CurrHinhPhatID = Convert.ToDecimal(hddHinhPhatChange.Value);
            if (CurrHinhPhatID > 0)
            {
                foreach (RepeaterItem item in rptHPChinh.Items)
                {
                    CheckBox chk = (CheckBox)item.FindControl("chk");
                    HiddenField hddHinhPhatID = (HiddenField)item.FindControl("hddHinhPhatID");
                    row_hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);

                    Panel pnZoneHinhPhat = (Panel)item.FindControl("pnZoneHinhPhat");

                    Panel pnThoiGianThuThach = (Panel)item.FindControl("pnThoiGianThuThach");
                    HiddenField hddLoai = (HiddenField)item.FindControl("hddLoai");
                    RadioButtonList rdDefaultTrue = (RadioButtonList)item.FindControl("rdDefaultTrue");
                    rdDefaultTrue.Visible = false;
                    if (chk.Checked)
                    {
                        if (row_hinhphat != CurrHinhPhatID)
                            pnZoneHinhPhat.Enabled = chk.Checked = false;
                        else
                        {
                            pnZoneHinhPhat.Enabled = true;
                            if (hddLoai.Value == ENUM_LOAIHINHPHAT.DEFAULT_TRUE.ToString())
                                rdDefaultTrue.SelectedValue = "1";
                            try
                            {
                                CheckBox chkAnTreo = (CheckBox)item.FindControl("chkAnTreo");
                                if (chkAnTreo.Checked)
                                {
                                    pnThoiGianThuThach.Visible = true;
                                    TextBox txtTGTT_Nam = (TextBox)item.FindControl("txtTGTT_Nam");
                                    Cls_Comon.SetFocus(this, this.GetType(), txtTGTT_Nam.ClientID);
                                }
                                else
                                    pnThoiGianThuThach.Visible = false;
                            }
                            catch (Exception exx) { }
                        }
                    }
                }
                foreach (RepeaterItem item in rptQDKhac.Items)
                {
                    CheckBox chk = (CheckBox)item.FindControl("chk");
                    HiddenField hddHinhPhatID = (HiddenField)item.FindControl("hddHinhPhatID");
                    row_hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);
                    HiddenField hddLoai = (HiddenField)item.FindControl("hddLoai");
                    RadioButtonList rdDefaultTrue = (RadioButtonList)item.FindControl("rdDefaultTrue");
                    rdDefaultTrue.Visible = false;
                    if (chk.Checked)
                    {
                        if (row_hinhphat != CurrHinhPhatID)
                            chk.Checked = false;
                        else
                        {
                            if (hddLoai.Value == ENUM_LOAIHINHPHAT.DEFAULT_TRUE.ToString())
                                rdDefaultTrue.SelectedValue = "1";
                        }
                    }
                }
                Cls_Comon.SetFocus(this, this.GetType(), cmdSaveHinhPhat.ClientID);
            }
        }
        
        void LoadDrop()
        {
            List<THA_BIAN> thaBiAns = dt.THA_BIAN.Where(x => x.ID == BiCanID).ToList();
            if (thaBiAns != null && thaBiAns.Count > 0)
            {
                dropBiCao.Items.Clear();
                foreach (THA_BIAN obj in thaBiAns)
                    dropBiCao.Items.Add(new ListItem(obj.HOTEN, obj.ID.ToString()));
                try
                {
                    if (Request["aID"] != null)
                        dropBiCao.SelectedValue = Request["aID"] + "";
                }
                catch (Exception ex) { }
            }
            //----------------------------------------
            List<DM_BOLUAT> lst = dt.DM_BOLUAT.Where(x => x.HIEULUC == 1
                            && x.LOAI == ENUM_LOAIVUVIEC.AN_HINHSU.ToString()).ToList<DM_BOLUAT>();
            dropBoLuat.Items.Clear();
            if (lst != null && lst.Count > 0)
            {
                if (thaBiAns.Count > 1)
                    dropBoLuat.Items.Add(new ListItem("--------Chọn--------", "0"));
                foreach (DM_BOLUAT obj in lst)
                    dropBoLuat.Items.Add(new ListItem(obj.TENBOLUAT, obj.ID.ToString()));
            }
        }
        protected void dropBiCao_SelectedIndexChanged(object sender, EventArgs e)
        {
            Response.Redirect("/QLAN/THA/QuyetDinh/Popup/PhucTham/pToiDanh.aspx?aID=" + dropBiCao.SelectedValue);
        }
        protected void dropBoLuat_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        protected void cmdQuayLai_Click(object sender, EventArgs e)
        {
            Response.Redirect("Edit.aspx");
        }

        //----------------------------------------------
        protected void cmdThemDieuLuat_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            decimal luatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            String Diem = txtDiem.Text.Trim();
            string Khoan = txtKhoan.Text.Trim();
            String Dieu = txtDieu.Text.Trim();

            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            int Loai_bo_luat = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HINHSU);
            DataTable tbl = objBL.SearchChinhXacTheoDK(luatid, Diem, Khoan, Dieu);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataRow row = tbl.Rows[0];
                SaveToiDanh(row);
            }
            hddPageIndex.Value = "1";
            LoadDsToiDanhByBiCan();
        }

        void SaveToiDanh(DataRow rowToiDanh)
        {
            Decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            decimal toidanhid = Convert.ToDecimal(rowToiDanh["ID"] + "");
            
            //Lay ds cac cap cha cua toi danh duoc chon
            String ArrSapXep = "";
            String[] arrToiDanh = null;
            ArrSapXep = rowToiDanh["ArrSapXep"] + "";
            arrToiDanh = ArrSapXep.Split('/');
            if (arrToiDanh != null && arrToiDanh.Length > 0)
            {
                decimal ChuongID = Convert.ToDecimal(arrToiDanh[0] + "");
                foreach (String strToiDanhID in arrToiDanh)
                {
                    if (strToiDanhID.Length > 0 && strToiDanhID != ChuongID.ToString())
                    {
                        toidanhid = Convert.ToDecimal(strToiDanhID);
                        InsertToiDanh(toidanhid, 0);
                    }
                }
                dt.SaveChanges();
            }

            lstMsgT.Text =  "Lưu điều luật áp dụng cho bị can thành công!";
        }
     
        void InsertToiDanh(Decimal toidanhid, decimal hinhphatid)
        {
            Boolean IsUpdate = false;

            BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            THA_PHUCTHAM_BANAN_DIEU_CT obj = new THA_PHUCTHAM_BANAN_DIEU_CT();
            try
            {
                obj = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_DIEU_CT>($"BICANID = {BiCanID} AND VUANID = {VuAnID} AND TOIDANHID = {toidanhid}").FirstOrDefault(); 
                if (obj != null)
                    IsUpdate = true;
                else
                    obj = new THA_PHUCTHAM_BANAN_DIEU_CT();
            }
            catch (Exception ex) { obj = new THA_PHUCTHAM_BANAN_DIEU_CT(); }
            if (!IsUpdate)
            {
                obj.BANANID = BanAnID;
                obj.BICANID = BiCanID;
                obj.VUANID = VuAnID;
                obj.DIEULUATID = boluatid;
                obj.TOIDANHID = toidanhid;

                obj.HINHPHATID = hinhphatid;
                if (hinhphatid > 0)
                {
                    decimal loai_hp = Convert.ToDecimal(dt.DM_HINHPHAT.Where(x => x.ID == hinhphatid).SingleOrDefault().LOAIHINHPHAT);
                    obj.LOAIHINHPHAT = loai_hp;
                    switch (Convert.ToInt16(loai_hp))
                    {
                        case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                            obj.TF_VALUE = 0;
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                            obj.SH_VALUE = 0;
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                            obj.TG_NGAY = 0;
                            obj.TG_THANG = 0;
                            obj.TG_NAM = 0;
                            break;
                        case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                            obj.K_VALUE1 = 0;
                            obj.K_VALUE2 = "";
                            break;
                        case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                            obj.TF_VALUE = 1;
                            break;
                    }
                }
                DataExtensions.Insert<THA_PHUCTHAM_BANAN_DIEU_CT>(obj);
            }
        }

        //----------------------------------------------
        public string row_td_change = "";
        public void LoadDsToiDanhByBiCan()
        {
            BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            int boluatid = Convert.ToInt32(dropBoLuat.SelectedValue);

            string curr_textsearch = "";
            DateTime ngaybh = DateTime.MinValue;

            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            decimal loaiboluat = Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU);
            THA_QUYETDINH_DIEULUAT_BL tqdb = new THA_QUYETDINH_DIEULUAT_BL();
            DataTable tbl = tqdb.GETALL_DIEULUAT_PT_PAGING(BiCanID, VuAnID, boluatid, curr_textsearch, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
                rpt.DataSource = null;
                rpt.DataBind();
                lblThongBaoHP.Text = "";
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                //DataRowView dv = (DataRowView)e.Item.DataItem;
                //LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                //bool StatusButton = cmdSaveHinhPhat.Enabled;
                //Cls_Comon.SetLinkButton(lbtXoa, StatusButton);

                //int MaGiaiDoanVuAn = (string.IsNullOrEmpty(hddGiaiDoanVuAn.Value)) ? 0 : Convert.ToInt32(hddGiaiDoanVuAn.Value);
                //if (MaGiaiDoanVuAn == ENUM_GIAIDOANVUAN.THULYGDT)
                //{
                //    Cls_Comon.SetLinkButton(lbtXoa, false);
                //}

                ////check vu an ket thuc de thong bao khong cho sua
                //Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                //if (anKetThuc)
                //{
                //    Cls_Comon.SetLinkButton(lbtXoa, false);
                //}
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblThongBaoHP.Text = "";
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());

            switch (e.CommandName)
            {
                case "Xoa":
                    xoa(curr_id);
                    Capnhat_THA_TONGHOPHINHPHAT();

                    break;
                case "HinhPhat":
                    Response.Redirect("ChonToiDanh.aspx");
                    break;
                case "view":
                    //Chi hien khung chon hinh phat khi toidanh co CoHinhPhat = 1
                    hddHinhPhatChange.Value = hddGroupChange.Value = "0";
                    LoadHinhPhatTheoToiDanh(curr_id);
                    break;
            }
        }
          
        #region Load hinh phat theo toi danh
        void LoadHinhPhatTheoToiDanh(Decimal ToiDanhID)
        {
            hddCurrToiDanhID.Value = ToiDanhID.ToString();
            DM_BOLUAT_TOIDANH objTD = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == ToiDanhID).SingleOrDefault();
            if (objTD != null)
            {
                int IsHinhPhat = String.IsNullOrEmpty(objTD.COHINHPHAT + "") ? 0 : Convert.ToInt16(objTD.COHINHPHAT);
                if (IsHinhPhat == 1)
                {
                    pnHinhPhat.Visible = true;
                    lttToiDanh.Text = "Cập nhật hình phạt";// + objTD.TENTOIDANH;

                    //---------Load 3 nhom dhp----------------------------
                    DM_DATAGROUP objG = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.NHOMHINHPHAT).SingleOrDefault();
                    List<DM_DATAITEM> lst = dt.DM_DATAITEM.Where(x => x.GROUPID == objG.ID).ToList<DM_DATAITEM>();
                    if (lst != null && lst.Count > 0)
                    {
                        Decimal GroupID = 0;
                        foreach (DM_DATAITEM data in lst)
                        {
                            GroupID = data.ID;
                            switch (data.MA + "")
                            {
                                case ENUM_NHOMHINHPHAT.NHOM_HPCHINH:
                                    lttNhomHPChinh.Text = data.TEN;
                                    try
                                    {
                                        LoadHinhPhatTheoGroup(GroupID, rptHPChinh);
                                    }
                                    catch (Exception ex) { }
                                    break;
                                case ENUM_NHOMHINHPHAT.NHOM_HPBOSUNG:
                                    lttNhomHPBoSung.Text = data.TEN;
                                    try
                                    {
                                        LoadListHinhPhatBoSung(GroupID);
                                    }
                                    catch (Exception ex) { }
                                    break;
                                case ENUM_NHOMHINHPHAT.NHOM_QDKHAC:
                                    lttNhomQDKhac.Text = data.TEN;
                                    try
                                    {
                                        LoadHinhPhatTheoGroup(GroupID, rptQDKhac);
                                    }
                                    catch (Exception ex) { }
                                    break;
                            }
                        }
                    }
                }
                else
                    pnHinhPhat.Visible = false; 
            }
        }
        void LoadHinhPhatTheoGroup(decimal GroupID, Repeater rptControl)
        {
            DM_BOLUAT_TOIDANH_HINHPHAT_BL obj = new DM_BOLUAT_TOIDANH_HINHPHAT_BL();

            List<DM_HINHPHAT> lst = dt.DM_HINHPHAT.Where(x => x.NHOMHINHPHAT == GroupID).ToList<DM_HINHPHAT>();
            if (lst != null && lst.Count > 0)
            {
                rptControl.DataSource = lst;
                rptControl.DataBind();
            }
        }

        void LoadListHinhPhatBoSung(decimal GroupID)
        {
            DM_BOLUAT_TOIDANH_HINHPHAT_BL obj = new DM_BOLUAT_TOIDANH_HINHPHAT_BL();
            List<DM_HINHPHAT> lst = dt.DM_HINHPHAT.Where(x => x.NHOMHINHPHAT == GroupID).ToList<DM_HINHPHAT>();
            if (lst != null && lst.Count > 0)
            {
                rptHPBoSung.DataSource = lst;
                rptHPBoSung.DataBind();
            }
        }
        protected void rptHP_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DM_HINHPHAT obj = (DM_HINHPHAT)e.Item.DataItem;
                HiddenField hddHinhPhatID = (HiddenField)e.Item.FindControl("hddHinhPhatID");
                decimal hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);
                decimal bican = Convert.ToDecimal(dropBiCao.SelectedValue);

                Decimal ToiDanhID = String.IsNullOrEmpty(hddCurrToiDanhID.Value) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);
                CheckBox chkAnTreo = (CheckBox)e.Item.FindControl("chkAnTreo");
                Panel pnCoQuanGiamSat = (Panel)e.Item.FindControl("pnCoQuanGiamSat");
                TextBox txtCoQuanGiamSat = (TextBox)e.Item.FindControl("txtCoQuanGiamSat");
                string noiCuTru = "";
                THA_BIAN biCanDauVu = dt.THA_BIAN.Where(x => x.ID == bican).FirstOrDefault();
                // noi cu tru bi can
                AHS_BICANBICAO biCan = dt.AHS_BICANBICAO.Where(x => x.ID == biCanDauVu.IDBICANHETHONG).FirstOrDefault();
                // lay noi cu tru huyen
                DM_HANHCHINH huyenBiCao = dt.DM_HANHCHINH.Where(x => x.ID == biCan.TAMTRU_HUYEN).FirstOrDefault();
                if (huyenBiCao != null)
                {
                    noiCuTru += huyenBiCao.MA_TEN;
                }

                if (obj.ISANTREO > 0)
                    chkAnTreo.Visible = true;
                else
                    chkAnTreo.Visible = false;

                //-------------------------------
                decimal group_id = (decimal)obj.NHOMHINHPHAT;
                string TINHTRANG_BIAN = null;
                THA_BIAN_QUYETDINH tbQD = null;
                THA_PHUCTHAM_BANAN_DIEU_CT objCT = null;
                CheckBox chk = (CheckBox)e.Item.FindControl("chk");
                chk.Attributes.Add("onchange", "ChangeHP(" + hinhphat + "," + group_id + ")");

                if (group_id == NhomHinhPhatBS)
                {
                    chkAnTreo.Checked = false;
                    chk.Visible = false;
                    try
                    {
                        objCT = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_DIEU_CT>($"BICANID = {bican} AND VUANID = {VuAnID} AND TOIDANHID ={ToiDanhID} AND HINHPHATID = {hinhphat} AND ISCHANGE = 1").FirstOrDefault();
                    }
                    catch (Exception ex) { }
                }
                else
                {
                    chk.Visible = true;
                    try
                    {
                        objCT = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_DIEU_CT>($"BICANID = {bican} AND VUANID = {VuAnID} AND TOIDANHID ={ToiDanhID} AND HINHPHATID = {hinhphat} AND ISCHANGE = 0").FirstOrDefault();
                        tbQD = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == bican && x.VUANID == VuAnID).FirstOrDefault();
                    }
                    catch (Exception ex) { }
                }
                if (objCT != null)
                {
                    hddGroupChange.Value = group_id.ToString();
                    if (group_id != NhomHinhPhatBS)
                    {
                        //chkAnTreo.Checked = true;
                        chk.Checked = true;
                        hddHinhPhatChange.Value = hinhphat.ToString();
                        if (tbQD != null)
                        {
                            TINHTRANG_BIAN = tbQD.TINHTRANG_BIAN;
                        }

                        int is_antreo = (string.IsNullOrEmpty(objCT.ISANTREO + "")) ? 0 : Convert.ToInt16(objCT.ISANTREO);
                        if (objCT.ISANTREO == 1)
                        {
                            chkAnTreo.Checked = true;
                            try
                            {
                                Panel pnThoiGianThuThach = (Panel)e.Item.FindControl("pnThoiGianThuThach");
                                pnThoiGianThuThach.Visible = true;

                                TextBox txtTGTT_Nam = (TextBox)e.Item.FindControl("txtTGTT_Nam");
                                TextBox txtTGTT_Thang = (TextBox)e.Item.FindControl("txtTGTT_Thang");
                                TextBox txtTGTT_Ngay = (TextBox)e.Item.FindControl("txtTGTT_Ngay");
                                txtTGTT_Nam.Text = (String.IsNullOrEmpty(objCT.TGTT_NAM + "")) ? "0" : objCT.TGTT_NAM.ToString();
                                txtTGTT_Thang.Text = (String.IsNullOrEmpty(objCT.TGTT_THANG + "")) ? "0" : objCT.TGTT_THANG.ToString();
                                txtTGTT_Ngay.Text = (String.IsNullOrEmpty(objCT.TGTT_NGAY + "")) ? "0" : objCT.TGTT_NGAY.ToString();

                                if (pnCoQuanGiamSat != null && objCT != null && objCT.COQUAN_GIAMSAT?.Trim() != "" && chkAnTreo.Checked && TINHTRANG_BIAN == ENUM_TINHTRANG_BIAN.TAM_GIAM)
                                {
                                    pnCoQuanGiamSat.Visible = true;
                                    txtCoQuanGiamSat.Text = objCT.COQUAN_GIAMSAT != null && objCT.COQUAN_GIAMSAT.Trim() != ""
                                        ? objCT.COQUAN_GIAMSAT
                                        : "Uỷ ban nhân dân" + noiCuTru;
                                }
                            }
                            catch (Exception ex) { }
                        }
                    }
                }
                else
                {
                    //chkAnTreo.Checked = false;
                    chk.Checked = false;
                }

                //----------------------
                HiddenField hddLoai = (HiddenField)e.Item.FindControl("hddLoai");
                int LoaiHinhPhat = Convert.ToInt32(obj.LOAIHINHPHAT);
                switch (LoaiHinhPhat)
                {
                    case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                        RadioButtonList rdTrueFalse = (RadioButtonList)e.Item.FindControl("rdTrueFalse");
                        rdTrueFalse.Visible = true;
                        if (objCT != null)
                            rdTrueFalse.SelectedValue = (String.IsNullOrEmpty(objCT.TF_VALUE + "")) ? "0" : objCT.TF_VALUE.ToString();
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                        TextBox txtSohoc = (TextBox)e.Item.FindControl("txtSohoc");
                        txtSohoc.Visible = true;
                        if (objCT != null)
                            txtSohoc.Text = (String.IsNullOrEmpty(objCT.SH_VALUE + "")) ? "0" : ((Int32)objCT.SH_VALUE).ToString("#,#", cul);

                        break;
                    case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                        Panel pnThoiGian = (Panel)e.Item.FindControl("pnThoiGian");
                        pnThoiGian.Visible = true;
                        TextBox txtNam = (TextBox)e.Item.FindControl("txtNam");
                        TextBox txtThang = (TextBox)e.Item.FindControl("txtThang");
                        TextBox txtNgay = (TextBox)e.Item.FindControl("txtNgay");
                        if (objCT != null)
                        {
                            txtNam.Text = (String.IsNullOrEmpty(objCT.TG_NAM + "")) ? "0" : objCT.TG_NAM.ToString();
                            txtThang.Text = (String.IsNullOrEmpty(objCT.TG_THANG + "")) ? "0" : objCT.TG_THANG.ToString();
                            txtNgay.Text = (String.IsNullOrEmpty(objCT.TG_NGAY + "")) ? "0" : objCT.TG_NGAY.ToString();
                        }
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                        Panel pnKhac = (Panel)e.Item.FindControl("pnKhac");
                        pnKhac.Visible = true;
                        TextBox txtKhac1 = (TextBox)e.Item.FindControl("txtKhac1");
                        TextBox txtKhac2 = (TextBox)e.Item.FindControl("txtKhac2");
                        if (objCT != null)
                        {
                            txtKhac1.Text = (String.IsNullOrEmpty(objCT.K_VALUE1 + "")) ? "0" : objCT.K_VALUE1.ToString();
                            txtKhac2.Text = (String.IsNullOrEmpty(objCT.K_VALUE2 + "")) ? "" : objCT.K_VALUE2.ToString();
                        }
                        break;
                    case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                        RadioButtonList rdDefaultTrue = (RadioButtonList)e.Item.FindControl("rdDefaultTrue");
                        rdDefaultTrue.Visible = false;
                        if (objCT != null)
                            rdDefaultTrue.SelectedValue = "1";
                        break;
                }
            }
        }

        protected void chkAnTreo_CheckedChanged(object sender, EventArgs e)
        {
            var chk = sender as CheckBox;
            if (chk == null)
                return;
            var repeaterItem = chk.NamingContainer as RepeaterItem;
            if (repeaterItem == null)
                return;

            var pnCoQuanGiamSat = repeaterItem.FindControl("pnCoQuanGiamSat") as Panel;
            var txtCoQuanGiamSat = repeaterItem.FindControl("txtCoQuanGiamSat") as TextBox;
            decimal bican = Convert.ToDecimal(dropBiCao.SelectedValue);

            THA_BIAN biCanDauVu = dt.THA_BIAN.Where(x => x.ID == bican).FirstOrDefault();
            // noi cu tru bi can
            AHS_BICANBICAO biCan = dt.AHS_BICANBICAO.Where(x => x.MABICAN == biCanDauVu.MABICAN).FirstOrDefault();
            string noiChapHanh = "";
            // lay noi cu tru huyen
            DM_HANHCHINH huyenBiCao = dt.DM_HANHCHINH.Where(x => x.ID == biCan.TAMTRU_HUYEN).FirstOrDefault();
            if (huyenBiCao != null)
            {
                noiChapHanh += huyenBiCao.MA_TEN;
            }
            THA_BIAN_QUYETDINH objCT = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == bican).FirstOrDefault();
            if (pnCoQuanGiamSat != null && chk.Checked && objCT != null && objCT.TINHTRANG_BIAN == ENUM_TINHTRANG_BIAN.TAM_GIAM)
            {
                pnCoQuanGiamSat.Visible = true;
                if (objCT != null && objCT.COQUAN_GIAMSAT != null && objCT.COQUAN_GIAMSAT.Trim() != "")
                {
                    txtCoQuanGiamSat.Text = objCT.COQUAN_GIAMSAT;
                }
                else
                {
                    txtCoQuanGiamSat.Text = "Uỷ ban nhân dân " + noiChapHanh;
                }
            }
            else
            {
                pnCoQuanGiamSat.Visible = false;
            }
        }
        protected void cmdSaveHinhPhat_Click(object sender, EventArgs e)
        {
            BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            Decimal ToiDanhID = String.IsNullOrEmpty(hddCurrToiDanhID.Value) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);

            DM_BOLUAT_TOIDANH dm = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == ToiDanhID).Single<DM_BOLUAT_TOIDANH>();
            Decimal boluatid = (decimal)dm.LUATID;

            Decimal NhomHinhPhatChange = String.IsNullOrEmpty(hddGroupChange.Value) ? 0 : Convert.ToDecimal(hddGroupChange.Value);

            if (NhomHinhPhatChange > 0)
            {
                string manhom = dt.DM_DATAITEM.Where(x => x.ID == NhomHinhPhatChange).Single<DM_DATAITEM>().MA;
                if (manhom == ENUM_NHOMHINHPHAT.NHOM_HPCHINH)
                    Update_HinhPhatChinh(rptHPChinh,  ToiDanhID, boluatid);
                else
                    Update_HinhPhatChinh(rptQDKhac,  ToiDanhID, boluatid);
            }
            else
            {
                Update_HinhPhatChinh(rptHPChinh, ToiDanhID, boluatid);
                Update_HinhPhatChinh(rptQDKhac,  ToiDanhID, boluatid);
            }
            Update_HinhPhatBS(rptHPBoSung, ToiDanhID, boluatid);
            lbthongbao.Text = "";

            Capnhat_THA_TONGHOPHINHPHAT();

            Capnhat_BieuMau_AnTreo(BiCanID);

            Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Cập nhật hình phạt cho bị cáo thành công!");
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
        }

        private void Capnhat_BieuMau_AnTreo(Decimal BiCanID)
        {
            THA_BIEUMAU_BL thaBieuMauBL = new THA_BIEUMAU_BL();
            thaBieuMauBL.DELETE_THA_FILE_VUANIDBIAN_QUYETDINH(VuAnID, BiCanID, ENUM_MA_BIEUMAU.THA_ANTREO);

            bool checkAnTreo = false;
            THA_BIAN_QUYETDINH tbq = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiCanID && x.VUANID == VuAnID).FirstOrDefault();
            List<THA_PHUCTHAM_BANAN_DIEU_CT> tsbdcs = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_DIEU_CT>($"VUANID = {VuAnID} AND BICANID = {BiCanID}");
            if (tsbdcs != null && tsbdcs.Count > 0)
            {
                foreach (THA_PHUCTHAM_BANAN_DIEU_CT tsbdc in tsbdcs)
                {
                    if (tsbdc.ISANTREO == 1)
                    {
                        checkAnTreo = true;
                        break;
                    }
                }
            }
            // Nếu tồn tại án treo thì thêm lại biểu mẫu
            if (checkAnTreo && tbq != null && tbq.TINHTRANG_BIAN == ENUM_TINHTRANG_BIAN.TAM_GIAM)
            {
                // xóa biểu mẫu thi hành án
                thaBieuMauBL.DELETE_THA_FILE_VUANIDBIAN_QUYETDINH(VuAnID, BiCanID, ENUM_MA_BIEUMAU.THA_TAMGIAM);

                string maBieuMau = ENUM_MA_BIEUMAU.THA_ANTREO;
                saveBieuMau(maBieuMau, VuAnID, BiCanID);
            }
            else if (tbq != null && tbq.TINHTRANG_BIAN == ENUM_TINHTRANG_BIAN.TAM_GIAM)
            {
                string maBieuMau = ENUM_MA_BIEUMAU.THA_TAMGIAM;
                saveBieuMau(maBieuMau, VuAnID, BiCanID);
            }
        }

        private void Capnhat_THA_TONGHOPHINHPHAT()
        {
            try
            {
                THA_TONGHOPHINHPHAT saveTHHP = new THA_TONGHOPHINHPHAT();
                if (!saveTHHP.Capnhat_Tonghophinhphat_byVuanAndBicanid(3,VuAnID,BiCanID, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), Session[ENUM_SESSION.SESSION_USERNAME] + ""))
                {
                    lbthongbao.Text = "Lỗi Tổng hợp hình phạt!";
                    return;
                }

            }
            catch (System.Data.Entity.Validation.DbEntityValidationException dbEx)
            {
                foreach (var validationErrors in dbEx.EntityValidationErrors)
                {
                    foreach (var validationError in validationErrors.ValidationErrors)
                    {
                        string a = "property: " + validationError.PropertyName + " Error: " + validationError.ErrorMessage;
                    }
                }
                lbthongbao.Text = "Lỗi Tổng hợp hình phạt!";
                return;
            }
        }

        #region Update hinh phat chinh, QDKhac
        THA_PHUCTHAM_BANAN_DIEU_CT obj;
        void Update_HinhPhatChinh(Repeater rpt,  Decimal ToiDanhID, Decimal boluatid)
        {
            BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);

            THA_BIAN_QUYETDINH objCT = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiCanID).FirstOrDefault();

            Decimal HinhPhatChinh = Convert.ToDecimal(hddHinhPhatChange.Value);
            Boolean IsUpdate = false;
            DM_BOLUAT_TOIDANH tentoidanh = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == ToiDanhID).Single<DM_BOLUAT_TOIDANH>();
            foreach (RepeaterItem itemHP in rpt.Items)
            {
                try
                {
                    HiddenField hddGroup = (HiddenField)itemHP.FindControl("hddGroup");
                    decimal CurrGroupID = Convert.ToDecimal(hddGroup.Value);

                    HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
                    TextBox txtCoQuanGiamSat = (TextBox)itemHP.FindControl("txtCoQuanGiamSat");
                    decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);
                    CheckBox chk = (CheckBox)itemHP.FindControl("chk");
                    if (hinhphatid == HinhPhatChinh && chk.Checked == true)
                    {
                        try
                        {
                            List<THA_PHUCTHAM_BANAN_DIEU_CT> listCheck = null;
                            listCheck = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_DIEU_CT>($"BICANID = {BiCanID} AND VUANID = {VuAnID} AND TOIDANHID = {ToiDanhID} AND ISCHANGE = 0");

                            if (listCheck != null && listCheck.Count > 0)
                            {
                                obj = listCheck[0];
                                IsUpdate = true;
                            }
                            else
                            {
                                IsUpdate = false;
                                obj = new THA_PHUCTHAM_BANAN_DIEU_CT();
                            }
                        }
                        catch (Exception ex)
                        {
                            obj = new THA_PHUCTHAM_BANAN_DIEU_CT();
                        }

                        //----------An treo & thoi gian thu thach----------------
                        obj.TGTT_NAM = 0;
                        obj.TGTT_THANG = 0;
                        obj.TGTT_NGAY = 0;
                        try
                        {
                            CheckBox chkAnTreo = (CheckBox)itemHP.FindControl("chkAnTreo");
                            obj.ISANTREO = (chkAnTreo.Checked) ? 1 : 0;

                            if (objCT != null && objCT.TINHTRANG_BIAN == ENUM_TINHTRANG_BIAN.TAM_GIAM && chkAnTreo.Checked)
                            {
                                obj.COQUAN_GIAMSAT = txtCoQuanGiamSat.Text?.Trim();
                            }

                            if (chkAnTreo.Checked)
                            {
                                TextBox txtTGTT_Nam = (TextBox)itemHP.FindControl("txtTGTT_Nam");
                                TextBox txtTGTT_Thang = (TextBox)itemHP.FindControl("txtTGTT_Thang");
                                TextBox txtTGTT_Ngay = (TextBox)itemHP.FindControl("txtTGTT_Ngay");
                                obj.TGTT_NAM = String.IsNullOrEmpty(txtTGTT_Nam.Text.Trim()) ? 0 : Convert.ToDecimal(txtTGTT_Nam.Text);
                                obj.TGTT_THANG = String.IsNullOrEmpty(txtTGTT_Thang.Text.Trim()) ? 0 : Convert.ToDecimal(txtTGTT_Thang.Text);
                                obj.TGTT_NGAY = String.IsNullOrEmpty(txtTGTT_Ngay.Text.Trim()) ? 0 : Convert.ToDecimal(txtTGTT_Ngay.Text);
                            }
                           
                        }catch(Exception exx) { }
                        //---------------------------------------
                        obj.ISCHANGE = 0;

                        obj.DIEULUATID = boluatid;
                        obj.TOIDANHID = ToiDanhID;
                        obj.HINHPHATID = hinhphatid;
                        obj.BANANID = BanAnID;
                        obj.BICANID = Convert.ToDecimal(dropBiCao.SelectedValue);

                        obj.ISMAIN = 0; //Hình phạt chính là 0, hình phạt bổ sung là null
                        obj.TENTOIDANH = tentoidanh.TENTOIDANH;

                        GetValue(obj, itemHP);
                        if (!IsUpdate)
                            DataExtensions.Insert(obj);
                        else
                            DataExtensions.Update(obj);
                    }
                }
                catch (Exception ex) { }
            }
        }

        private void saveBieuMau(String maBieuMau, decimal VuAnID, decimal BiAnID)
        {
            DM_BIEUMAU bIEUMAU = dt.DM_BIEUMAU.Where(x => x.MABM == maBieuMau).FirstOrDefault();
            THA_FILE tHA_FILE = DataExtensions
                .GetAllWithClause<THA_FILE>($"VUANID = {VuAnID} AND BIANID = {BiAnID} AND BIEUMAUID = {bIEUMAU.ID}")
                .FirstOrDefault();
            if (tHA_FILE == null)
            {
                THA_FILE fileBieuMau = new THA_FILE();
                fileBieuMau.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                fileBieuMau.VUANID = VuAnID;
                fileBieuMau.BIEUMAUID = bIEUMAU.ID;
                fileBieuMau.MAGIAIDOAN = 2;
                fileBieuMau.NGAYTAO = DateTime.Now;
                fileBieuMau.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                fileBieuMau.BIANID = BiAnID;
                fileBieuMau.LOAIFILE = 0;
                DataExtensions.Insert<THA_FILE>(fileBieuMau);
            }
        }

        void GetValue(THA_PHUCTHAM_BANAN_DIEU_CT obj, RepeaterItem itemHP)
        {
            HiddenField hddLoai = (HiddenField)itemHP.FindControl("hddLoai");
            decimal loai_hp = Convert.ToDecimal(hddLoai.Value);
            obj.LOAIHINHPHAT = loai_hp;

            HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
            decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);
            obj.HINHPHATID = hinhphatid;

            obj.TF_VALUE = obj.SH_VALUE = obj.TG_NAM = obj.TG_THANG = obj.TG_THANG = 0;
            obj.K_VALUE1 = 0;
            obj.K_VALUE2 = "";

            switch (Convert.ToInt16(loai_hp))
            {
                case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                    obj.TF_VALUE = 1;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                    RadioButtonList rdTrueFalse = (RadioButtonList)itemHP.FindControl("rdTrueFalse");
                    obj.TF_VALUE = Convert.ToDecimal(rdTrueFalse.SelectedValue);
                    break;
                case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                    TextBox txtSohoc = (TextBox)itemHP.FindControl("txtSohoc");
                    obj.SH_VALUE = (String.IsNullOrEmpty(txtSohoc.Text)) ? 0 : Convert.ToDecimal(txtSohoc.Text.Replace(".", ""));
                    break;
                case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                    TextBox txtNam = (TextBox)itemHP.FindControl("txtNam");
                    TextBox txtThang = (TextBox)itemHP.FindControl("txtThang");
                    TextBox txtNgay = (TextBox)itemHP.FindControl("txtNgay");
                    obj.TG_NGAY = String.IsNullOrEmpty(txtNgay.Text) ? 0 : Convert.ToDecimal(txtNgay.Text);
                    obj.TG_THANG = String.IsNullOrEmpty(txtThang.Text) ? 0 : Convert.ToDecimal(txtThang.Text);
                    obj.TG_NAM = String.IsNullOrEmpty(txtNam.Text) ? 0 : Convert.ToDecimal(txtNam.Text);
                    break;
                case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                    TextBox txtKhac1 = (TextBox)itemHP.FindControl("txtKhac1");
                    TextBox txtKhac2 = (TextBox)itemHP.FindControl("txtKhac2");
                    obj.K_VALUE1 = String.IsNullOrEmpty(txtKhac1.Text) ? 0 : Convert.ToDecimal(txtKhac1.Text);
                    obj.K_VALUE2 = txtKhac2.Text.Trim();
                    break;
            }
        }

        protected void rptHPBoSung_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DM_HINHPHAT obj = (DM_HINHPHAT)e.Item.DataItem;

                HiddenField hddHinhPhatID = (HiddenField)e.Item.FindControl("hddHinhPhatID");
                decimal hinhphat = Convert.ToDecimal(hddHinhPhatID.Value);
                decimal bican = Convert.ToDecimal(dropBiCao.SelectedValue);

                Decimal ToiDanhID = String.IsNullOrEmpty(hddCurrToiDanhID.Value) ? 0 : Convert.ToDecimal(hddCurrToiDanhID.Value);
                CheckBox chkAnTreo = (CheckBox)e.Item.FindControl("chkAnTreo");
                if (obj.ISANTREO > 0)
                    chkAnTreo.Visible = true;
                else
                    chkAnTreo.Visible = false;

                //-------------------------------
                decimal group_id = (decimal)obj.NHOMHINHPHAT;
                THA_PHUCTHAM_BANAN_DIEU_CT objCT = null;
                CheckBox chk = (CheckBox)e.Item.FindControl("chk");
                chk.Attributes.Add("onchange", "ChangeHP(" + hinhphat + "," + group_id + ")");

                chkAnTreo.Checked = false;

                try
                {
                    objCT = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_DIEU_CT>($"BICANID = {BiCanID} AND VUANID = {VuAnID} AND TOIDANHID = {ToiDanhID} AND HINHPHATID = {hinhphat} AND ISCHANGE = 1").FirstOrDefault();
                    if (objCT != null)
                    {
                        hddGroupChange.Value = group_id.ToString();
                        if (group_id != NhomHinhPhatBS)
                        {
                          //  chkAnTreo.Checked = true;
                            chk.Checked = true;
                            hddHinhPhatChange.Value = hinhphat.ToString();
                        }
                    }
                    else
                    {
                        objCT = new THA_PHUCTHAM_BANAN_DIEU_CT();
                        //chkAnTreo.Checked = false;
                        chk.Checked = false;
                    }
                }
                catch (Exception ex)
                {
                    objCT = new THA_PHUCTHAM_BANAN_DIEU_CT();
                    //chkAnTreo.Checked = false;
                    chk.Checked = false;
                }

                //----------------------
                HiddenField hddLoai = (HiddenField)e.Item.FindControl("hddLoai");
                int LoaiHinhPhat = Convert.ToInt32(obj.LOAIHINHPHAT);
                switch (LoaiHinhPhat)
                {
                    case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                        CheckBox chkDefaultTrue = (CheckBox)e.Item.FindControl("chkDefaultTrue");
                        chkDefaultTrue.Visible = true;
                        if (!String.IsNullOrEmpty(objCT.TF_VALUE + ""))
                            chkDefaultTrue.Checked = (objCT.TF_VALUE == 1) ? true : false;
                        
                        break;

                    case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                        CheckBox chkTrueFalse = (CheckBox)e.Item.FindControl("chkTrueFalse");
                        chkTrueFalse.Visible = true;
                        if (!String.IsNullOrEmpty(objCT.TF_VALUE + ""))
                            chkTrueFalse.Checked = (objCT.TF_VALUE == 1) ? true : false;
                        
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                        TextBox txtSohoc = (TextBox)e.Item.FindControl("txtSohoc");
                        txtSohoc.Visible = true;
                        if (objCT != null)
                            txtSohoc.Text = (String.IsNullOrEmpty(objCT.SH_VALUE + "")) ? "0" : ((Int32)objCT.SH_VALUE).ToString("#,#", cul);
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                        Panel pnThoiGian = (Panel)e.Item.FindControl("pnThoiGian");
                        pnThoiGian.Visible = true;
                        TextBox txtNam = (TextBox)e.Item.FindControl("txtNam");
                        TextBox txtThang = (TextBox)e.Item.FindControl("txtThang");
                        TextBox txtNgay = (TextBox)e.Item.FindControl("txtNgay");
                        if (objCT != null)
                        {
                            txtNam.Text = (String.IsNullOrEmpty(objCT.TG_NAM + "")) ? "0" : objCT.TG_NAM.ToString();
                            txtThang.Text = (String.IsNullOrEmpty(objCT.TG_THANG + "")) ? "0" : objCT.TG_THANG.ToString();
                            txtNgay.Text = (String.IsNullOrEmpty(objCT.TG_NGAY + "")) ? "0" : objCT.TG_NGAY.ToString();
                        }
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                        Panel pnKhac = (Panel)e.Item.FindControl("pnKhac");
                        pnKhac.Visible = true;
                        TextBox txtKhac1 = (TextBox)e.Item.FindControl("txtKhac1");
                        TextBox txtKhac2 = (TextBox)e.Item.FindControl("txtKhac2");
                        if (objCT != null)
                        {
                            txtKhac1.Text = (String.IsNullOrEmpty(objCT.K_VALUE1 + "")) ? "0" : objCT.K_VALUE1.ToString();
                            txtKhac2.Text = (String.IsNullOrEmpty(objCT.K_VALUE2 + "")) ? "" : objCT.K_VALUE2.ToString();
                        }
                        break;
                }
            }
        }
        #endregion

        #region Update hinh phat bo sung
        void Update_HinhPhatBS(Repeater rpt, Decimal ToiDanhID, Decimal boluatid)
        {
            Boolean IsUpdate = false;
            Decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            foreach (RepeaterItem itemHP in rpt.Items)
            {
                try
                {
                    IsUpdate = false;

                    HiddenField hddGroup = (HiddenField)itemHP.FindControl("hddGroup");
                    decimal CurrGroupID = Convert.ToDecimal(hddGroup.Value);

                    HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
                    decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);
                    //KT da co hinhphat bo sung nay trong DB?? 
                    try
                    {
                        List<THA_PHUCTHAM_BANAN_DIEU_CT> listCheck = null;
                        //AND HINHPHATID = {hinhphatid}
                        listCheck = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_DIEU_CT>($"BICANID = {BiCanID} AND VUANID = {VuAnID} AND TOIDANHID = {ToiDanhID} AND ISCHANGE = 1");
                        
                        if (listCheck != null && listCheck.Count > 0)
                        {
                            foreach (THA_PHUCTHAM_BANAN_DIEU_CT item in listCheck)
                            {
                                if ((string.IsNullOrEmpty(item.ISCHANGE + "") || item.ISCHANGE == 0) && (item.HINHPHATID == 0))
                                {
                                    IsUpdate = true;
                                    obj = item;
                                    break;
                                }
                                else
                                {
                                    if (item.HINHPHATID > 0 && item.HINHPHATID == hinhphatid)
                                    {
                                        IsUpdate = true;
                                        break;
                                    }
                                    else
                                        IsUpdate = false;
                                }
                            }
                        }
                        else IsUpdate = false;
                        if (!IsUpdate)
                            obj = new THA_PHUCTHAM_BANAN_DIEU_CT();
                    }
                    catch (Exception ex)
                    {
                        obj = new THA_PHUCTHAM_BANAN_DIEU_CT();
                    }


                    obj.ISCHANGE = 1;
                    obj.DIEULUATID = boluatid;
                    obj.TOIDANHID = ToiDanhID;
                    obj.BANANID = BanAnID;
                    obj.BICANID = Convert.ToDecimal(dropBiCao.SelectedValue);
                    Boolean IsEdit = GetValue_HPBoSung(obj, itemHP);

                    if (!IsEdit)
                    {
                        //DL ko thay doi (so voi gia tri mac dinh cua control)
                        //--> Xoa hinh phat di (neu dang co trong db)
                        if (IsUpdate)
                        {
                            //da co hinh phat nay trong db
                            DataExtensions.Delete(obj);
                        }
                    }
                    else
                    {
                        if (!IsUpdate)
                        {
                            DataExtensions.Insert(obj);
                        }
                        else
                        {
                            DataExtensions.Update(obj);
                        }
                    }
                }
                catch (Exception ex) { }
            }
        }

        Boolean GetValue_HPBoSung(THA_PHUCTHAM_BANAN_DIEU_CT obj, RepeaterItem itemHP)
        {
            Boolean IsEdit = false;
            HiddenField hddLoai = (HiddenField)itemHP.FindControl("hddLoai");
            decimal loai_hp = Convert.ToDecimal(hddLoai.Value);
            obj.LOAIHINHPHAT = loai_hp;

            HiddenField hddHinhPhatID = (HiddenField)itemHP.FindControl("hddHinhPhatID");
            decimal hinhphatid = Convert.ToDecimal(hddHinhPhatID.Value);
            obj.HINHPHATID = hinhphatid;

            obj.TF_VALUE = obj.SH_VALUE = obj.TG_NAM = obj.TG_THANG = obj.TG_THANG = 0;
            obj.K_VALUE1 = 0;
            obj.K_VALUE2 = "";

            switch (Convert.ToInt16(loai_hp))
            {
                case ENUM_LOAIHINHPHAT.DEFAULT_TRUE:
                    // RadioButtonList rdDefaultTrue = (RadioButtonList)itemHP.FindControl("rdDefaultTrue");
                    CheckBox chkDefaultTrue = (CheckBox)itemHP.FindControl("chkDefaultTrue");
                    //if (rdDefaultTrue.SelectedValue == "1")
                    if (chkDefaultTrue.Checked)
                    {
                        IsEdit = true;
                        obj.TF_VALUE = 1;
                    }
                    else obj.TF_VALUE = 0;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                    //   RadioButtonList rdTrueFalse = (RadioButtonList)itemHP.FindControl("rdTrueFalse");
                    CheckBox chkTrueFalse = (CheckBox)itemHP.FindControl("chkTrueFalse");
                    obj.TF_VALUE = (chkTrueFalse.Checked) ? 1 : 0;
                    if (chkTrueFalse.Checked)
                        IsEdit = true;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                    TextBox txtSohoc = (TextBox)itemHP.FindControl("txtSohoc");
                    obj.SH_VALUE = (String.IsNullOrEmpty(txtSohoc.Text)) ? 0 : Convert.ToDecimal(txtSohoc.Text.Replace(".", ""));
                    if (obj.SH_VALUE > 0)
                        IsEdit = true;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                    TextBox txtNam = (TextBox)itemHP.FindControl("txtNam");
                    TextBox txtThang = (TextBox)itemHP.FindControl("txtThang");
                    TextBox txtNgay = (TextBox)itemHP.FindControl("txtNgay");
                    obj.TG_NGAY = String.IsNullOrEmpty(txtNgay.Text) ? 0 : Convert.ToDecimal(txtNgay.Text);
                    obj.TG_THANG = String.IsNullOrEmpty(txtThang.Text) ? 0 : Convert.ToDecimal(txtThang.Text);
                    obj.TG_NAM = String.IsNullOrEmpty(txtNam.Text) ? 0 : Convert.ToDecimal(txtNam.Text);
                    if ((obj.TG_NAM > 0) || (obj.K_VALUE1 > 0) || (obj.K_VALUE1 > 0))
                        IsEdit = true;
                    break;
                case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                    TextBox txtKhac1 = (TextBox)itemHP.FindControl("txtKhac1");
                    TextBox txtKhac2 = (TextBox)itemHP.FindControl("txtKhac2");
                    obj.K_VALUE1 = String.IsNullOrEmpty(txtKhac1.Text) ? 0 : Convert.ToDecimal(txtKhac1.Text);
                    obj.K_VALUE2 = txtKhac2.Text.Trim();
                    if (obj.K_VALUE1 > 0)
                        IsEdit = true;
                    if (!String.IsNullOrEmpty(obj.K_VALUE2))
                        IsEdit = true;
                    break;
            }
            return IsEdit;
        }
        #endregion
        #endregion

        public void xoa(decimal toidanhid)
        {
            decimal BiCanIDSelected = Convert.ToDecimal(dropBiCao.SelectedValue);
            Decimal CurrID = 0;
            List<THA_PHUCTHAM_BANAN_DIEU_CT> lst = null;
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetAllByParentID(toidanhid);
            foreach (DataRow row in tbl.Rows)
            {
                try
                {
                    CurrID = Convert.ToDecimal(row["ID"] + "");
                    lst = DataExtensions.GetAllWithClause<THA_PHUCTHAM_BANAN_DIEU_CT>($"TOIDANHID = {toidanhid} AND BICANID = {BiCanIDSelected} AND VUANID = {VuAnID}");
                    
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (THA_PHUCTHAM_BANAN_DIEU_CT obj in lst)
                            DataExtensions.Delete<THA_PHUCTHAM_BANAN_DIEU_CT>(obj);
                    }
                }catch(Exception ex) { }
            }
            dt.SaveChanges();

            hddPageIndex.Value = "1";
            LoadDsToiDanhByBiCan();
            lblThongBaoHP.Text = "";
            lbthongbao.Text = "Xóa thành công!";
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadDsToiDanhByBiCan();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDsToiDanhByBiCan();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDsToiDanhByBiCan();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDsToiDanhByBiCan();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDsToiDanhByBiCan();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; lblThongBaoHP.Text = ""; }
        }
        #endregion       
    }
}