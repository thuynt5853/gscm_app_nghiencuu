
using System;
using System.Data;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Module.Common;
using System.Globalization;

using DAL.DKK;
using BL.DonKK;
using BL.DonKK.DanhMuc;

using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;


namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class DangKyNhanVB : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
        Decimal UserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadDrop();
                    LoadDropTuCachToTung();
                    LoadThongTinUser();
                    //LoadDSDonKienLienQuan();
                    ltNgayThuLy.Text = " <span style='color:red'>*</span>";
                    ltSoThuLy.Text = " <span style='color:red'>*</span>";
                    if (!string.IsNullOrEmpty(Request["ID"]))
                    {
                        decimal ID = Convert.ToDecimal(Request["ID"] + "");
                        IDOLD.Value = ID.ToString();
                        DONKK_USER_DKNHANVB obj = dt.DONKK_USER_DKNHANVB.FirstOrDefault(s => s.ID == ID);
                        ddlTucachTotung.SelectedValue = obj.TUCACHTOTUNG_MA;
                        string capsetxu = "";
                        if (obj.MALOAIVUVIEC== ENUM_LOAIAN.AN_DANSU)
                        {
                            if (gsdt.ADS_PHUCTHAM_BANAN.Count(s=>s.DONID==obj.VUVIECID)>0)
                            {
                                capsetxu = "PHUCTHAM";
                            }
                            else
                            {
                                capsetxu = "SOTHAM";
                            }
                        }
                        else if (obj.MALOAIVUVIEC == ENUM_LOAIAN.AN_HANHCHINH)
                        {
                            if (gsdt.AHC_PHUCTHAM_BANAN.Count(s => s.DONID == obj.VUVIECID) > 0)
                            {
                                capsetxu = "PHUCTHAM";
                            }
                            else
                            {
                                capsetxu = "SOTHAM";
                            }
                        }
                        else if (obj.MALOAIVUVIEC == ENUM_LOAIAN.AN_HONNHAN_GIADINH)
                        {
                            if (gsdt.AHN_PHUCTHAM_BANAN.Count(s => s.DONID == obj.VUVIECID) > 0)
                            {
                                capsetxu = "PHUCTHAM";
                            }
                            else
                            {
                                capsetxu = "SOTHAM";
                            }
                        }
                        else if (obj.MALOAIVUVIEC == ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI)
                        {
                            if (gsdt.AKT_PHUCTHAM_BANAN.Count(s => s.DONID == obj.VUVIECID) > 0)
                            {
                                capsetxu = "PHUCTHAM";
                            }
                            else
                            {
                                capsetxu = "SOTHAM";
                            }
                        }
                        else if (obj.MALOAIVUVIEC == ENUM_LOAIAN.AN_LAODONG)
                        {
                            if (gsdt.ALD_PHUCTHAM_BANAN.Count(s => s.DONID == obj.VUVIECID) > 0)
                            {
                                capsetxu = "PHUCTHAM";
                            }
                            else
                            {
                                capsetxu = "SOTHAM";
                            }
                        }
                        else if (obj.MALOAIVUVIEC == ENUM_LOAIAN.AN_PHASAN)
                        {
                            if (gsdt.ALD_PHUCTHAM_BANAN.Count(s => s.DONID == obj.VUVIECID) > 0)
                            {
                                capsetxu = "AN_PHASAN";
                            }
                            else
                            {
                                capsetxu = "AN_PHASAN";
                            }
                        }
                        LoadDSDonKienLienQuan(obj.DUONGSUID.Value,obj.MALOAIVUVIEC,capsetxu);
                    }
                }
                txtToaAn.Attributes.Add("onblur", "Load_data_theodk();");
            }
            else Response.Redirect("/Trangchu.aspx");
        }
        void LoadDropTuCachToTung()
        {
            String MaTuCachKoSD = "$TGTTDS_01$TGTTDS_02$TGTTDS_08$TGTTDS_09$";
            ddlTucachTotung.Items.Clear();
            string temp = "";
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTGTTDS);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddlTucachTotung.Items.Add(new ListItem("Nguyên đơn/ Người khởi kiện", "NGUYENDON"));
                ddlTucachTotung.Items.Add(new ListItem("Bị đơn/ Người bị kiện", "BIDON"));
                ddlTucachTotung.Items.Add(new ListItem("Người có quyền và NVLQ", "QUYENNVLQ"));
                ddlTucachTotung.Items.Add(new ListItem("Người được ủy quyền", "TGTTDS_01"));
                foreach (DataRow row in tbl.Rows)
                {
                    temp = "$" + row["MA"].ToString() + "$";
                    if (! MaTuCachKoSD.Contains(temp))
                        ddlTucachTotung.Items.Add(new ListItem(row["Ten"].ToString(), row["MA"].ToString()));
                }
            }
        }
        void LoadThongTinUser()
        {
            DONKK_USERS_BL objUserBL = new DONKK_USERS_BL();
            DataTable tbl = objUserBL.GetInfo(UserID);
            if (tbl != null && tbl.Rows.Count ==1)
            {
                DataRow row = tbl.Rows[0];
                lttDuongSu.Text = row["NDD_HOTEN"] + "";
                lttCMND.Text = row["NDD_CMND"] + "";
                
                //-------------------------------------------------------
                String Email =(String.IsNullOrEmpty(row["Email"] +""))? "": row["Email"].ToString();
                if (!string.IsNullOrEmpty(Email))
                {
                    lttEmail.Text = "<tr>";
                    lttEmail.Text += "<td class='cell_label'>Email: </td>";
                    lttEmail.Text += "<td colspan='3'>" + Email + "</td>";
                    lttEmail.Text += "</tr>";
                }

                //------------------
                String strDiachi = (String.IsNullOrEmpty(row["DIACHI_CHITIET"] + "")) ? "" : row["DIACHI_CHITIET"].ToString();
                strDiachi = (String.IsNullOrEmpty(row["TamTru_CHITIET"] + "")) ? "" : row["TamTru_CHITIET"].ToString();
                strDiachi += (String.IsNullOrEmpty(row["DC_TamTru_Huyen"] + "")) ? "" : (((!String.IsNullOrEmpty(strDiachi)) ? ", " : "") + row["DC_TamTru_Huyen"].ToString());
                if (!string.IsNullOrEmpty(strDiachi))
                {
                    lttDiachi.Text += "<tr>";
                    lttDiachi.Text += "<td class='cell_label'>Nơi đang sinh sống: </td>";
                    lttDiachi.Text += "<td colspan='3'>" + strDiachi + "</td>";
                    lttDiachi.Text += "</tr>";
                }
                //-------------------------------------------------------
                lttQuocTich.Text = row["QuocTich"] +"";
                //-------------------------
                int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
                if (MucDichSD == 2)
                {
                    lttGhichu.Text = "<li>";
                    lttGhichu.Text += "Sau khi đăng ký nhận văn bản, thông báo mới từ Tòa án thành công, bạn cần in đăng ký và đem hồ sơ, giấy tờ tương ứng đến Tòa án để xác nhận đăng ký hợp lệ ";
                    lttGhichu.Text += "</li>";
                }
                else
                    lttGhichu.Text = "";

                try {
                    Cls_Comon.SetValueComboBox(ddlTucachTotung, row["TuCachTT"].ToString());
                } catch(Exception ex) { }
            }

            //----------------------
            try
            {
                Decimal QuanID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_QUAN_ID] + "");
                DM_TOAAN objTA = gsdt.DM_TOAAN.Where(x => x.HANHCHINHID == QuanID).Single<DM_TOAAN>();
                if (objTA != null)
                {
                    txtToaAn.Text = objTA.MA_TEN;
                    hddToaAnID.Value = objTA.ID.ToString();
                    LoadDropCapXetXu(objTA.LOAITOA);
                }
            }
            catch (Exception ex) { }
        }
        
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (!CheckDK())
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn chưa chọn vụ việc yêu cầu gửi văn bản, thông báo. Hãy kiểm tra lại!");
                return;
            }
           
            String MaDangKy = Cls_Comon.Randomnumber();
            String Group_DK = Guid.NewGuid().ToString();
            Decimal curr_id = (string.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            //-------------------------------
            DONKK_USER_DKNHANVB obj = null;
            Decimal  VuAnID =0, QLAn_DuongSuID = 0;
            String  MaLoaiVuViec="", TenVuViec="", MaVuViec="";

            String TuCachToTung_Ma = ddlTucachTotung.SelectedValue;
            decimal TuCachTT_Id = 0;
            try { TuCachTT_Id = gsdt.DM_DATAITEM.Where(x => x.MA == TuCachToTung_Ma).SingleOrDefault().ID; }catch(Exception ex) { }
            Decimal ToaAnID = 0;
            try
            {
                ToaAnID = (String.IsNullOrEmpty(hddToaAnID.Value + "")) ? 0 : Convert.ToDecimal(hddToaAnID.Value);
            }catch(Exception ex) { }
            string SoCMND = lttCMND.Text.Trim();
          
            //-------------------------
            Boolean isNew = false;
            int count_daco = 0;
            String VuViecDaDK = "";
            string ListVuViecDKNhanVB = "";
            string temp = "";
            int ma_giai_doan = 0;
            int count_themmoi = 0;
            foreach (RepeaterItem item in rpt.Items)
            {                
                CheckBox chk = (CheckBox)item.FindControl("chk");
                if (chk.Checked)
                {
                    isNew = false;
                    #region Lay thong tin tu hidden field
                    HiddenField hddToaSoTham = (HiddenField)item.FindControl("hddToaSoTham");
                    HiddenField hddToaPhucTham = (HiddenField)item.FindControl("hddToaPhucTham");
                    HiddenField hddMaGiaiDoan = (HiddenField)item.FindControl("hddMaGiaiDoan");
                    ma_giai_doan = (String.IsNullOrEmpty(hddMaGiaiDoan.Value + "")) ? 0 : Convert.ToInt16(hddMaGiaiDoan.Value);
                    if (ma_giai_doan <= 2)
                        ToaAnID = (String.IsNullOrEmpty(hddToaSoTham.Value + "")) ? 0 : Convert.ToDecimal(hddToaSoTham.Value);
                    else
                        ToaAnID = (String.IsNullOrEmpty(hddToaPhucTham.Value + "")) ? 0 : Convert.ToDecimal(hddToaPhucTham.Value);

                    //--------------------------------
                    MaLoaiVuViec = TenVuViec = MaVuViec = temp = "";
                    HiddenField hddQLAn_DuongSuID = (HiddenField)item.FindControl("hddQLAn_DuongSuID");
                    QLAn_DuongSuID = Convert.ToDecimal(hddQLAn_DuongSuID.Value);

                    HiddenField hddVuAnID = (HiddenField)item.FindControl("hddVuAnID");
                    VuAnID = Convert.ToDecimal(hddVuAnID.Value);

                    HiddenField hddMaLoaiVuViec = (HiddenField)item.FindControl("hddMaLoaiVuViec");
                    MaLoaiVuViec = hddMaLoaiVuViec.Value;
                    HiddenField hddTenVuViec = (HiddenField)item.FindControl("hddTenVuViec");
                    TenVuViec = hddTenVuViec.Value;

                    HiddenField hddMaVuViec = (HiddenField)item.FindControl("hddMaVuViec");
                    MaVuViec = hddMaVuViec.Value;

                    HiddenField hddMaTuCachTT = (HiddenField)item.FindControl("hddMaTuCachTT");
                    TuCachToTung_Ma = hddMaTuCachTT.Value;
                    try { TuCachTT_Id = gsdt.DM_DATAITEM.Where(x => x.MA == TuCachToTung_Ma).SingleOrDefault().ID; } catch (Exception ex) { }

                    #endregion
                    try
                    {
                        obj = dt.DONKK_USER_DKNHANVB.Where(x => x.USERID == UserID 
                                                            && x.TOAANID == ToaAnID
                                                            && x.TUCACHTOTUNG_MA == TuCachToTung_Ma                                                            
                                                            && x.DUONGSUID == QLAn_DuongSuID
                                                            && x.TRANGTHAI <2).Single<DONKK_USER_DKNHANVB>();
                        if (obj == null)
                        {
                            isNew = true;
                            obj = new DONKK_USER_DKNHANVB();
                        }
                        else
                        {
                            if (VuViecDaDK.Length > 0)
                                VuViecDaDK += ", ";
                            VuViecDaDK += MaVuViec + (String.IsNullOrEmpty(obj.MADANGKY+"") ? "": " (Mã ĐK: " + obj.MADANGKY + ")");
                            count_daco++;
                        }
                    }catch(Exception ex) { obj = new DONKK_USER_DKNHANVB(); isNew = true; }
                    
                    //them moi----------------
                    if (isNew)
                    {
                        ThemMoiDK(Group_DK, MaDangKy, temp, ListVuViecDKNhanVB
                            , ToaAnID, MaLoaiVuViec
                            , VuAnID, TenVuViec, MaVuViec , QLAn_DuongSuID);
                        count_themmoi++;
                    }
                }
            }
            if (count_themmoi > 0)
            {
                string link = "/Personnal/ChiTietDKNhanVB.aspx?group=" + Group_DK;
                Response.Redirect(link);
            }
            else
            {
                if (count_daco>0)
                    lttThongBao.Text = "Lưu ý: " + ((count_daco<=1)? "": "các") +" vụ việc có mã sau: " + VuViecDaDK + "</br> đã được đăng ký nên không thể đăng ký lại!" ;
            }
        }

        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                string Maloaivuan = rowView["MaLoaiVuAn"].ToString();
                decimal LoaiAn = Convert.ToDecimal(rowView["VuAnID"]);
                Panel panel = (Panel)e.Item.FindControl("pnItem");
                CheckBox checkBox = (CheckBox)e.Item.FindControl("chk");
                decimal? ToaAnId = 0;
                string thongbao = "";
                if (Maloaivuan == ENUM_LOAIAN.AN_DANSU)
                {
                    ADS_DON odon = new ADS_DON();
                    odon=gsdt.ADS_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                    if (odon!=null)
                    {
                        while (true)
                        {
                            LoaiAn = odon.ID;
                            ToaAnId = odon.TOAANID;
                            odon = gsdt.ADS_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                            if (odon == null)
                            {
                                break;
                            }
                        }
                        DM_TOAAN oToaAn = gsdt.DM_TOAAN.FirstOrDefault(s => s.ID == ToaAnId);
                        thongbao = "Đơn đã được chuyển đến " + oToaAn.TEN;
                        panel.Attributes.Add("thongbao", thongbao);
                        checkBox.Visible = false;
                    }
                    
                    
                }
                else if (Maloaivuan == ENUM_LOAIAN.AN_HONNHAN_GIADINH)
                {
                    AHN_DON odon = new AHN_DON();
                    odon = gsdt.AHN_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                    if (odon != null)
                    {
                        while (true)
                        {
                            LoaiAn = odon.ID;
                            ToaAnId = odon.TOAANID;
                            odon = gsdt.AHN_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                            if (odon == null)
                            {
                                break;
                            }
                        }
                        DM_TOAAN oToaAn = gsdt.DM_TOAAN.FirstOrDefault(s => s.ID == ToaAnId);
                        thongbao = "Đơn đã được chuyển đến " + oToaAn.TEN;
                        panel.Attributes.Add("thongbao", thongbao);
                        checkBox.Visible = false;
                    }
                }
                else if (Maloaivuan == ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI)
                {
                    AKT_DON odon = new AKT_DON();
                    odon = gsdt.AKT_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                    if (odon != null)
                    {
                        while (true)
                        {
                            LoaiAn = odon.ID;
                            ToaAnId = odon.TOAANID;
                            odon = gsdt.AKT_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                            if (odon == null)
                            {
                                break;
                            }
                        }
                        DM_TOAAN oToaAn = gsdt.DM_TOAAN.FirstOrDefault(s => s.ID == ToaAnId);
                        thongbao = "Đơn đã được chuyển đến " + oToaAn.TEN;
                        panel.Attributes.Add("thongbao", thongbao);
                        checkBox.Visible = false;
                    }
                }
                else if (Maloaivuan == ENUM_LOAIAN.AN_LAODONG)
                {
                    ALD_DON odon = new ALD_DON();
                    odon = gsdt.ALD_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                    if (odon != null)
                    {
                        while (true)
                        {
                            LoaiAn = odon.ID;
                            ToaAnId = odon.TOAANID;
                            odon = gsdt.ALD_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                            if (odon == null)
                            {
                                break;
                            }
                        }
                        DM_TOAAN oToaAn = gsdt.DM_TOAAN.FirstOrDefault(s => s.ID == ToaAnId);
                        thongbao = "Đơn đã được chuyển đến " + oToaAn.TEN;
                        panel.Attributes.Add("thongbao", thongbao);
                        checkBox.Visible = false;
                    }
                }
                else if (Maloaivuan == ENUM_LOAIAN.AN_HANHCHINH)
                {
                    AHC_DON odon = new AHC_DON();
                    odon = gsdt.AHC_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                    if (odon != null)
                    {
                        while (true)
                        {
                            LoaiAn = odon.ID;
                            ToaAnId = odon.TOAANID;
                            odon = gsdt.AHC_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                            if (odon == null)
                            {
                                break;
                            }
                        }
                        DM_TOAAN oToaAn = gsdt.DM_TOAAN.FirstOrDefault(s => s.ID == ToaAnId);
                        thongbao = "Đơn đã được chuyển đến " + oToaAn.TEN;
                        panel.Attributes.Add("thongbao", thongbao);
                        checkBox.Visible = false;
                    }
                }
                else if (Maloaivuan == ENUM_LOAIAN.AN_PHASAN)
                {
                    APS_DON odon = new APS_DON();
                    odon = gsdt.APS_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                    if (odon != null)
                    {
                        while (true)
                        {
                            LoaiAn = odon.ID;
                            ToaAnId = odon.TOAANID;
                            odon = gsdt.APS_DON.FirstOrDefault(s => s.DONID_TOACU == LoaiAn);
                            if (odon == null)
                            {
                                break;
                            }
                        }
                        DM_TOAAN oToaAn = gsdt.DM_TOAAN.FirstOrDefault(s => s.ID == ToaAnId);
                        thongbao = "Đơn đã được chuyển đến " + oToaAn.TEN;
                        panel.Attributes.Add("thongbao", thongbao);
                        checkBox.Visible = false;
                    }
                }
            }
        }
        void ThemMoiDK(String Group_DK, String MaDangKy, String temp, string ListVuViecDKNhanVB
            , Decimal ToaAnID, String MaLoaiVuViec
            , Decimal VuAnID, string TenVuViec, string MaVuViec, Decimal QLAn_DuongSuID )
        {
            String TuCachToTung_Ma = ddlTucachTotung.SelectedValue;
            decimal TuCachTT_Id = 0;
            try { TuCachTT_Id = gsdt.DM_DATAITEM.Where(x => x.MA == TuCachToTung_Ma).SingleOrDefault().ID; } catch (Exception ex) { }
           

            DONKK_USER_DKNHANVB obj = new DONKK_USER_DKNHANVB();
            obj.GROUPDK = Group_DK;
            obj.TOAANID = ToaAnID;
            obj.DONKKID = 0;
            obj.DUONGSUID = QLAn_DuongSuID;

            obj.VUVIECID = VuAnID;
            obj.TENVUVIEC = TenVuViec;
            obj.MAVUVIEC = MaVuViec;

            obj.TUCACHTOTUNG_MA = TuCachToTung_Ma;
            obj.TUCACHTOTUNG_ID = TuCachTT_Id;

            obj.USERID = UserID;
            obj.CMND = lttCMND.Text.Trim();
            obj.TENDUONGSU = lttDuongSu.Text.Trim();

            obj.MALOAIVUVIEC = MaLoaiVuViec;
            obj.NGAYTAO = DateTime.Now;

            //int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
            //if (MucDichSD == 1)
            //    obj.TRANGTHAI = 1;
            //else
                obj.TRANGTHAI = 0;

            obj.MADANGKY = MaDangKy;
            dt.DONKK_USER_DKNHANVB.Add(obj);
            dt.SaveChanges();
            string strIdDangky = Session["DANGKY"] == null ? "" : Session["DANGKY"].ToString();
            if (!string.IsNullOrEmpty(strIdDangky))
            {
                strIdDangky = strIdDangky.Replace("," + IDOLD.Value + ",", ",");
                Session["DANGKY"] = strIdDangky;
            }
            //---------------------
            #region Lay thong tin vu viec dk de ghi log            
            temp += "- Vụ việc:";
            temp += "+ Lĩnh vực: ";
            switch (MaLoaiVuViec)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    temp += "Dân sự";
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    temp += "Hành chính";
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    temp += "Hôn nhân & Gia đình";
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    temp += "Kinh doanh & Thương mại";
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    temp += "Lao động";
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    temp += "Phá sản";
                    break;
            }
            temp += "+ Mã vụ việc:" + MaVuViec + ",";
            temp += "+ Tên vụ việc:" + TenVuViec + ",";
            //--------------
            ListVuViecDKNhanVB += (String.IsNullOrEmpty(ListVuViecDKNhanVB)) ? temp : ("<br/>" + temp);
            #endregion

            //---------------------
            try
            {
                SendMail(TenVuViec);
            }
            catch (Exception ex) { }
            try
            {
                GhiLog(ListVuViecDKNhanVB);
            }
            catch (Exception ex) { }
        }
        Boolean  CheckDK()
        {
            Boolean retval=false;
            foreach (RepeaterItem item in rpt.Items)
            {
                CheckBox chk = (CheckBox)item.FindControl("chk");
                if (chk.Checked)
                {
                    retval = true;
                    break;
                }
            }
            return retval;
        }
        void GhiLog(String ListMaVuViecDKNhanVB)
        {
            String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            decimal UserID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String Detail_Action = CurrUserName + " - Đăng ký nhận văn bản, thông báo mới từ Tòa án.<br/>";
            Detail_Action += "Gồm: " + ListMaVuViecDKNhanVB;

            String KeyLog = ENUM_HD_NGUOIDUNG_DKK.DKNHANVB;
            
            DONKK_USER_HISTORY_BL objBL = new DONKK_USER_HISTORY_BL();
            objBL.WriteLog(UserID, KeyLog, Detail_Action);
        }
        void SendMail(String tenvuviec)
        {
            String CurrUserName = Session[ENUM_SESSION.SESSION_USERTEN] + "";
            string CurrEmail = dt.DONKK_USERS.Where(x => x.ID == UserID).SingleOrDefault().EMAIL;

            //----------send mail------------------------
            string ThoiGian = DateTime.Now.ToString("dd/MM/yyyy", cul);
            string MaThongBao = "XNDangKyNhanVBTongDat";
            String NoiDung = "", TieuDe = "";
            DAL.GSTP.DM_TRANGTINH obj = gsdt.DM_TRANGTINH.Where(x => x.MATRANG == MaThongBao).SingleOrDefault();
            if (obj != null)
            {
                NoiDung = obj.NOIDUNG;
                TieuDe = obj.TENTRANG;
            }
            if (!string.IsNullOrEmpty(NoiDung))
            {
                //Hệ thống tự động xác nhận ngừng nhận văn bản, thông báo từ Tòa án của vụ việc {0} tới người dùng {1} tại thời điểm:{2}. Cám ơn!
                NoiDung = String.Format(NoiDung, tenvuviec, CurrUserName, ThoiGian);
            }
            Cls_Comon.SendEmail(CurrEmail, TieuDe, NoiDung);
        }
        void ClearForm()
        {
            txtToaAn.Text = "";
            hddToaAnID.Value = "";
            ddlTucachTotung.SelectedValue = "";
            hddPageIndex.Value = "0";
            rpt.Visible = pnPagingTop.Visible = pnPagingBottom.Visible = false;
            lttThongBao.Text = "";
        }

        //------------------------
        void LoadDrop()
        {
            ddlTucachTotung.Items.Clear();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.TUCACHTOTUNG_DS);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ddlTucachTotung.Items.Add(new ListItem("---------Tất cả---------", ""));
                foreach (DataRow row in tbl.Rows)
                    ddlTucachTotung.Items.Add(new ListItem(row["TEN"] + "", row["Ma"] + ""));
            }

        }
        #region Load DS

        void LoadDropCapXetXu(string loai_toa)
        {
            dropCapXetXu.Items.Clear();
            switch (loai_toa)
            {
                case "CAPCAO":
                    dropCapXetXu.Items.Add(new ListItem("Sơ thẩm", "SOTHAM"));
                    dropCapXetXu.Items.Add(new ListItem("Phúc thẩm", "PHUCTHAM"));
                   // dropCapXetXu.Items.Add(new ListItem("Giám đốc thẩm tái thẩm", "THULYGDT"));
                    break;
                case "CAPTINH":
                    dropCapXetXu.Items.Add(new ListItem("Sơ thẩm", "SOTHAM"));
                    dropCapXetXu.Items.Add(new ListItem("Phúc thẩm", "PHUCTHAM"));
                    break;
                case "CAPHUYEN":
                    dropCapXetXu.Items.Add(new ListItem("Sơ thẩm", "SOTHAM"));
                    break;
            }
        }
        protected void cmdSetCapXetXu_Click(object sender, EventArgs e)
        {
            rpt.Visible = pnPagingTop.Visible = pnPagingBottom.Visible = false;
            if (!String.IsNullOrEmpty(txtToaAn.Text.Trim()))
            {
                decimal toa_an_id = (string.IsNullOrEmpty(hddToaAnID.Value)) ? 0 : Convert.ToDecimal(hddToaAnID.Value);
                try
                {
                    DM_TOAAN objTA = gsdt.DM_TOAAN.Where(x => x.ID == toa_an_id).Single();
                    if (objTA != null)
                        LoadDropCapXetXu(objTA.LOAITOA);
                }
                catch (Exception ex)
                {
                    //lttBatBuoc.Text = "";
                }
            }
            else
            {
                Cls_Comon.ShowMessageZone(this, this.GetType(), "Thông báo", "Bạn chưa chọn Tòa án thụ lý vụ việc. Hãy kiểm tra lại!");
                return;
            }
        }
        private bool valid()
        {
            if (!chkBoxThuLy.Checked)
            {
                if (string.IsNullOrEmpty(txtSothuly.Text))
                {
                    lttThongBao.Text = "Vui lòng nhập số thụ lý";
                    txtSothuly.Focus();
                    return false;
                }
                else if (string.IsNullOrEmpty(txtNgaythuly.Text))
                {
                    lttThongBao.Text = "Vui lòng nhập ngày thụ lý";
                    txtNgaythuly.Focus();
                    return false;
                }
            }
            
            //else if (string.IsNullOrEmpty(txtNamsinh.Text))
            //{
            //    lttThongBao.Text = "Vui lòng nhập năm sinh";
            //    txtNamsinh.Focus();
            //    return false;
            //}
            return true;
        }

        protected void chkLinked_CheckedChanged(Object sender, EventArgs args)
        {
            CheckBox linkedItem = sender as CheckBox;
            if (linkedItem.Checked)
            {
                //bỏ bắt buộc
                ltNgayThuLy.Text = "";
                ltSoThuLy.Text = "";
            }
            else
            {
                //có bắt buộc
                ltNgayThuLy.Text = " <span style='color:red'>*</span>";
                ltSoThuLy.Text = " <span style='color:red'>*</span>";
            }
        }
        protected void cmdTraCuu_Click(object sender, EventArgs e)
        {
            if (!valid())
            {
                return;
            }
            rpt.Visible = pnPagingTop.Visible = pnPagingBottom.Visible = false;
            if (!String.IsNullOrEmpty(txtToaAn.Text.Trim()))
            {
                decimal toa_an_id = (string.IsNullOrEmpty(hddToaAnID.Value)) ? 0 : Convert.ToDecimal(hddToaAnID.Value);

                if (toa_an_id > 0)
                {
                    hddPageIndex.Value = "1";
                    LoadDSDonKienLienQuan();
                }
            }
            else
            {
                Cls_Comon.ShowMessageZone(this, this.GetType(), "Thông báo", "Bạn chưa chọn Tòa án thụ lý vụ việc. Hãy kiểm tra lại!");
                return;
            }
        }

        public void LoadDSDonKienLienQuan(decimal DUONGSUID=0,string MAVUVIEC="",string capsx="")
        {
            cmdUpdate.Visible = true;
            lttThongBao.Text = "";
            int page_size =Convert.ToInt16(hddPageSize.Value);
            decimal toa_an_id = (string.IsNullOrEmpty(hddToaAnID.Value))?0: Convert.ToDecimal(hddToaAnID.Value );
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            string tucach_tt = ddlTucachTotung.SelectedValue;
            DataTable tbl = null;
            DONKK_DON_BL oBL = new DONKK_DON_BL();
            string hoten = lttDuongSu.Text.Trim();
            string email = Session[ENUM_SESSION.SESSION_USERNAME]+"";
            //String sobanan = txtSoBAST.Text.Trim();
            string sothuly = txtSothuly.Text;
            string ngaythuly = txtNgaythuly.Text;
            string namsinh = string.Empty;
            string capxetxu = dropCapXetXu.SelectedValue;
            string vcmnd = lttCMND.Text;
            DateTime? ngaybanan = DateTime.MinValue;// (String.IsNullOrEmpty(txtNgayBAST.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBAST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (DUONGSUID!=0 && !string.IsNullOrEmpty(MAVUVIEC))
            {
                hoten = "";
                email = "";
                capxetxu = capsx;
                 vcmnd = "";
            }
            tbl = oBL.SearchQLAnByTuCachTT(hoten, email, toa_an_id, tucach_tt, sothuly, ngaythuly, namsinh, capxetxu, vcmnd, DUONGSUID, MAVUVIEC,  pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"]);
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                cmdUpdate.Visible = true;
                rpt.Visible = pnPagingTop.Visible = pnPagingBottom.Visible = true;
            }
            else
            {
                rpt.Visible = pnPagingTop.Visible = pnPagingBottom.Visible = false;
                cmdUpdate.Visible = true;
                if (tucach_tt != "")
                    lttThongBao.Text = "Không tìm thấy vụ việc nào có tư cách tố tụng là '" + ddlTucachTotung.SelectedItem.Text + "'!";
                else
                    lttThongBao.Text = "Không tìm thấy vụ việc nào mà người dùng có tham gia!";
            }
        }
        //protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        DataRowView rv = (DataRowView)e.Item.DataItem;

        //        //int trangthai = Convert.ToInt16(rv["TrangThai"] + "");
        //        //Literal lttEdit = (Literal)e.Item.FindControl("lttEdit");
        //        //string img_temp = "";
        //        //if (trangthai > 0)
        //        //{
        //        //    img_temp = "<img src='/UI/img/view.png' alt='Xem'/>";
        //        //    lttEdit.Text = "<a href=''>" + img_temp + "</a>";
        //        //}
        //        //else
        //        //{
        //        //    img_temp = "<img src='/UI/img/edit.png' alt='Sửa'/>";
        //        //    lttEdit.Text = "<a href='/Personnal/DangKyNhanVB.aspx?vID=" + rv["ID"].ToString() + "'>" + img_temp + "</a>";
        //        //}
        //    }
        //}

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    xoa(ND_id);
                    break;
            }
        }
      
        #region "Phân trang ds duong su"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadDSDonKienLienQuan();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadDSDonKienLienQuan();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadDSDonKienLienQuan();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadDSDonKienLienQuan();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadDSDonKienLienQuan();
        }

        #endregion
        public void xoa(decimal id)
        {
            DONKK_USER_DKNHANVB oND = dt.DONKK_USER_DKNHANVB.Where(x => x.ID == id).FirstOrDefault();
            dt.DONKK_USER_DKNHANVB.Remove(oND);
            dt.SaveChanges();

            // lttMsg.Text = "<div class='msg_thongbao'>Xóa đăng ký thành công!</div>";

            hddPageIndex.Value = "1";
            LoadDSDonKienLienQuan();
        }
        #endregion

        protected void cmdBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Personnal/DsDangKyNhanVBTongDat.aspx");
        }

    }
}