using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Web;
using BL.GSTP.GDTTT;
using System.Text;
using BL.GSTP.BANGSETGET;
using BL.GSTP.Danhmuc;

namespace WEB.GSTP.QLAN.GDTTT.VT_DEN
{
    public partial class Van_ban_den_form : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal PhongBanID = 0, CurrDonViID = 0, UserID = 0;
        String UserName = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            if (!IsPostBack)
            {
                LoadDiaChiGui();
                LoadDiaChi_NguoiDungDon();
                //danh sach
                NoiNhan_Load_Search();
                LanhDao_Load_Search(CurrDonViID+"");
                Toa_an_ra_BAQD_Load_Search();
                LoadAllLoaiAn_Search();
                Load_TrangThaiChuyen();
                Check_btn_chuyenNhan();
                //danh sach end
                //---popup
                LoadDrop_Drop_LOAI_AN_DON();
                //LoadAllLoaiAn();
                //LoadAllLoaiAn_hs();
                QuanHePL_hs();
                Load_Capxx();
                BA_QD_Load();
                LoaiVB_Load();
                DONVI_GQ_Load();
                //Load can bo thuoc do vi giai quyet
                CAN_BO_Load(CurrDonViID + "", Drop_DVXULY_ID_DON.SelectedValue);
                NoiNhan_Load(CurrDonViID + "");
                LanhDao_Load(CurrDonViID + "");
                LoadDropNGuoiKy_VKS();
               // Soden_Get_Values();
                Toa_an_ra_BAQD_Load();
                CHECKBY_NGUONDEN();
                //---popup end
                SetGetSessionTK(false);
                //Load_Data();
                //Check_column_dgList();   
                Display_validate();
                DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PhongBanID).FirstOrDefault();
                if (CurrDonViID == 1 && obj.ISGIAIQUYETDON == 1)
                {
                    Drop_NOI_NHAN_SEARCH.SelectedValue = PhongBanID.ToString();
                    Drop_NOI_NHAN_SEARCH.Enabled = false;
                }
            }
           
        }

        private void LoadDrop_Drop_LOAI_AN_DON()
        {
            //Loại án
            Drop_LOAI_AN_DON.Items.Clear();
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            decimal PBID = strPBID == "" ? 0 : Convert.ToDecimal(strPBID); ;
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PBID).FirstOrDefault() ?? new DM_PHONGBAN();
            if (obj != null)
            {
                if (obj.ISHINHSU == 1)
                {
                    Drop_LOAI_AN_DON.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU));
                }
                if (obj.ISDANSU == 1) Drop_LOAI_AN_DON.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC_NUMBER.AN_DANSU));
                if (obj.ISHANHCHINH == 1) Drop_LOAI_AN_DON.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH));
                if (obj.ISHNGD == 1) Drop_LOAI_AN_DON.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH));
                if (obj.ISKDTM == 1) Drop_LOAI_AN_DON.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI));
                if (obj.ISLAODONG == 1) Drop_LOAI_AN_DON.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG));
                //if (obj.ISPHASAN == 1) Drop_LOAI_AN_DON.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN));
                if (Drop_LOAI_AN_DON.Items.Count > 1 && obj.ISHINHSU != 1)
                    Drop_LOAI_AN_DON.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
            else
            {
                Drop_LOAI_AN_DON.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU));
                Drop_LOAI_AN_DON.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC_NUMBER.AN_DANSU));
                Drop_LOAI_AN_DON.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH));
                Drop_LOAI_AN_DON.Items.Add(new ListItem("Hôn nhân gia đình", ENUM_LOAIVUVIEC_NUMBER.AN_HONNHAN_GIADINH));
                Drop_LOAI_AN_DON.Items.Add(new ListItem("Kinh doanh, thương mại", ENUM_LOAIVUVIEC_NUMBER.AN_KINHDOANH_THUONGMAI));
                Drop_LOAI_AN_DON.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC_NUMBER.AN_LAODONG));
                Drop_LOAI_AN_DON.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
            }
        }




        private void LoadDiaChiGui()
        {
            ddl_DIACHI_GUI_BT_ID.Items.Clear();
            List<DM_HANHCHINH> lstTinhHuyen;
            if (Session["DMTINHHUYEN"] == null)
                lstTinhHuyen = dt.DM_HANHCHINH.OrderBy(x => x.ARRTHUTU).ToList();
            else
                lstTinhHuyen = (List<DM_HANHCHINH>)(Session["DMTINHHUYEN"]);
            ddl_DIACHI_GUI_BT_ID.DataSource = lstTinhHuyen;
            ddl_DIACHI_GUI_BT_ID.DataTextField = "MA_TEN";
            ddl_DIACHI_GUI_BT_ID.DataValueField = "ID";
            ddl_DIACHI_GUI_BT_ID.DataBind();
            ddl_DIACHI_GUI_BT_ID.Items.Insert(0, new ListItem("---Tỉnh/Huyện---", "0"));
        }
        private void LoadDiaChi_NguoiDungDon()
        {
            ddl_DIACHI_NDD_ID.Items.Clear();

            List<DM_HANHCHINH> lstTinhHuyen;
            if (Session["DMTINHHUYEN"] == null)
                lstTinhHuyen = dt.DM_HANHCHINH.OrderBy(x => x.ARRTHUTU).ToList();
            else
                lstTinhHuyen = (List<DM_HANHCHINH>)(Session["DMTINHHUYEN"]);
            ddl_DIACHI_NDD_ID.DataSource = lstTinhHuyen;
            ddl_DIACHI_NDD_ID.DataTextField = "MA_TEN";
            ddl_DIACHI_NDD_ID.DataValueField = "ID";
            ddl_DIACHI_NDD_ID.DataBind();
            ddl_DIACHI_NDD_ID.Items.Insert(0, new ListItem("---Tỉnh/Huyện---", "0"));
        }        
        private void SetGetSessionTK(bool isSet)
        {
            try
            {
                if (isSet)
                {

                }
                else
                {
                    txt_NGAY_FROM.Text = Session[SS_TK.NGAYNHAPTU] + "";
                    txt_NGAY_TO.Text = Session[SS_TK.NGAYNHAPDEN] + "";
                    Drop_LOAI_AN_DON_SEARCH.SelectedValue=Session[SS_TK.LOAIAN] + "";
                    Drop_TRANGTHAICHUYEN.SelectedValue = Session[SS_TK.TRANGTHAICHUYEN_VT] + "";
                }
            }
            catch (Exception ex) { }
        }
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            MP_Add.Show();
            ScriptManager.RegisterStartupScript(Ajax_Manager_Updata, this.GetType(), "chosen_Load_Popup_clear", "chosen_Load_Popup_clear()", true);
            Drop_LOAI_VB.SelectedValue = string.Empty;           
            LoaiVB_Load();
            Drop_LOAI_VB.Enabled = true;
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PhongBanID).FirstOrDefault();

            if (CurrDonViID == 1 && obj.ISGIAIQUYETDON==1)//24/04/2005
            {
                Drop_LOAI_VB.SelectedValue = "4";
                Drop_LOAI_VB_SelectedIndexChanged(sender, e);
                Drop_LOAI_VB.Enabled = false;
            }
            if (CurrDonViID == 1 && obj.ISGIAIQUYETDON == 1)//24/04/2005 NOI_NHAN=0
            {
                Drop_NOI_NHAN.SelectedValue = PhongBanID.ToString();
                Drop_NOI_NHAN.Enabled = false;
            }
            // Soden_Get_Values();
            cmdUpdate.Visible = true;
        }
        #region danh sach tim kiem
        #endregion
        #region popup them moi
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                lbtthongbao_popup.Text = "";
                //----
                if (CheckData() == false)
                {
                    return;
                }
                if (Drop_LOAI_VB.SelectedValue == "4")
                {
                    lblInforBA.Text = "Thông tin Bản án/Quyết định bị Kháng nghị";
                    lblLoaiDeNghi.Text ="Kháng nghị theo thủ tục";
                }
                else
                {
                    lblInforBA.Text = "Thông tin Bản án/Quyết định";
                    lblLoaiDeNghi.Text = "Đề nghị theo thủ tục";
                }
                VT_VANBANDEN o_Object = new VT_VANBANDEN();
                int ids = 0;
                if (Hi_update.Value != "") { ids = Convert.ToInt32(Hi_update.Value); lbtthongbao_popup.Text = "Đã cập nhật thành công"; }
                o_Object.ID = ids;
                /////bì thư
                o_Object.LOAI_VB = Convert.ToInt32(Drop_LOAI_VB.SelectedValue);
                if (txt_NGAY_DEN.Text != "")
                o_Object.NGAY_DEN = DateTime.Parse(this.txt_NGAY_DEN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                o_Object.NGUOI_GUI_BT = txt_NGUOI_GUI_BT.Text.Trim();
                o_Object.DIACHI_GUI_BT_ID = Convert.ToDecimal(ddl_DIACHI_GUI_BT_ID.SelectedValue);
                o_Object.DIACHI_GUI_BT = txt_DIACHI_GUI_BT.Text.Trim();
                if (txt_NGAY_BT.Text!="")
                o_Object.NGAY_BT = DateTime.Parse(this.txt_NGAY_BT.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if(Drop_NOI_NHAN.SelectedValue!="")
                o_Object.NOI_NHAN = Convert.ToDecimal(Drop_NOI_NHAN.SelectedValue);
                o_Object.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]+"");
                o_Object.NGUON_DEN = Convert.ToDecimal(Drop_NGUONDEN.SelectedValue);
                if (Drop_NGUONDEN.SelectedValue == "1")
                {
                    o_Object.MABD = txt_MABUUDIEN.Text.Trim();
                    //if (txt_SOLUONG_GAM.Text !="")
                    //    o_Object.SOLUONG_GAM = Convert.ToDecimal(txt_SOLUONG_GAM.Text.Trim());
                }
                if (txt_SODEN.Text != "")
                {
                    o_Object.SODEN = Convert.ToDecimal(txt_SODEN.Text);
                }
                if (Drop_NGUOI_NHAN.SelectedValue != "")
                {
                    o_Object.NGUOI_NHAN = Convert.ToDecimal(Drop_NGUOI_NHAN.SelectedValue);
                }
                if (txt_SOLUONG_GAM.Text.Trim() != "")
                    o_Object.SOLUONG_GAM = Convert.ToDecimal(txt_SOLUONG_GAM.Text.Trim());
                o_Object.GHICHU = txt_GHICHU.Text.Trim();
                  string vLoaiVB = Drop_LOAI_VB.SelectedValue;
                //---Nhập thông tin văn bản hành chính
                if (Drop_LOAI_VB.SelectedValue == "5")
                {
                    o_Object.SO_VB = txt_SO_VB.Text.Trim();
                    if (txt_NGAY_VB.Text != "")
                        o_Object.NGAY_VB = DateTime.Parse(this.txt_NGAY_VB.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    o_Object.NOIDUNG_VB = txt_NOIDUNG_VB.Text.Trim();
                    o_Object.DO_KHAN_ID = drop_DOKHAN.SelectedValue;
                    o_Object.DOMAT_ID = drop_DOMAT.SelectedValue;
                }
                //---Nhập thông tin đon
                if (Drop_LOAI_VB.SelectedValue == "1" || Drop_LOAI_VB.SelectedValue == "3")
                {
                    if (txt_SOLUONG_DON.Text.Trim() != "")
                        o_Object.SOLUONG_DON = Convert.ToDecimal(txt_SOLUONG_DON.Text.Trim());                   
                    o_Object.NGUOIDUNGDON = txt_NGUOIDUNG_DON.Text.Trim();
                    o_Object.DIACHI_NDD_ID = Convert.ToDecimal(ddl_DIACHI_NDD_ID.SelectedValue);
                    o_Object.DIACHI_NDD = txt_DIACHI_NG_DUNGDON.Text.Trim();
                }
                //---Công văn chuyển đơn (CV)
                 if (Drop_LOAI_VB.SelectedValue == "2" )
                {
                    o_Object.SO_CV = txt_SO_CV.Text.Trim();
                    if (txt_NGAY_CV.Text != "")
                        o_Object.NGAY_CV = DateTime.Parse(this.txt_NGAY_CV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    o_Object.DONVICHUYEN_CV = txt_DONVICHUYEN_CV.Text.Trim();
                    o_Object.NOIDUNG_CV = txt_NOIDUNG_CV.Text.Trim();
                    
                }
                //---Công văn chuyển đơn (đơn + CV) + sử dụng chung với Công văn kiến nghị
                if (Drop_LOAI_VB.SelectedValue == "3" || Drop_LOAI_VB.SelectedValue == "6" || Drop_LOAI_VB.SelectedValue == "9")
                {
                    o_Object.SO_CV = txt_SO_CV.Text.Trim();
                    if (txt_NGAY_CV.Text != "")
                        o_Object.NGAY_CV = DateTime.Parse(this.txt_NGAY_CV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    o_Object.DONVICHUYEN_CV = txt_DONVICHUYEN_CV.Text.Trim();
                    o_Object.NOIDUNG_CV = txt_NOIDUNG_CV.Text.Trim();
                    
                }
                //---Hồ sơ
                 if (Drop_LOAI_VB.SelectedValue == "4")
                {
                    o_Object.SO_HS = txtSOKN.Text.Trim();
                    if (txt_NGAYQDKN.Text != "")
                        o_Object.NGAY_HS = DateTime.Parse(this.txt_NGAYQDKN.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    if(dropVKS_NguoiKy.SelectedValue!="")
                    o_Object.DONVICHUYEN_HS = Convert.ToDecimal(dropVKS_NguoiKy.SelectedValue);
                    o_Object.GHICHU_HS = txt_GHICHU_HS.Text.Trim();
                }
                //end
                 if (vLoaiVB == "1" || vLoaiVB == "3"|| vLoaiVB == "4" || vLoaiVB == "6" || vLoaiVB == "9")
                {
                    if(drop_LoaiGDT.SelectedValue !="")
                        o_Object.LOAI_GDTTTT = Convert.ToInt32(drop_LoaiGDT.SelectedValue);
                    o_Object.BAQD_CHECK_DON = Convert.ToInt32(rdb_BAQD_CHECK.SelectedValue);
                    if (rdb_BAQD_CHECK.SelectedValue == "1")
                    {
                        
                        o_Object.LOAI_AN_DON = Convert.ToDecimal(Drop_LOAI_AN_DON.SelectedValue);
                        o_Object.CAP_XX_DON = Convert.ToDecimal(Drop_CAP_XX_DON.SelectedValue);
                        o_Object.SO_BAQD_DON = txt_SO_BAQD_DON.Text.Trim();
                        if (txt_NGAY_BAQD_DON.Text != "")
                            o_Object.NGAY_BAQD_DON = DateTime.Parse(this.txt_NGAY_BAQD_DON.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                        o_Object.TOAAN_BAQD_DON = Convert.ToDecimal(Drop_TOAAN_BAQD_DON.SelectedValue);

                        if (Drop_LOAI_AN_DON.SelectedValue == "1")
                        {
                            o_Object.BIDON_DON = txt_BICAO_HS.Text;
                            if (Drop_QHPL.SelectedValue != "")
                                o_Object.QHPL_HS_DON = Convert.ToDecimal(Drop_QHPL.SelectedValue);
                            else
                                o_Object.QHPL_HS_DON = 0;
                        }
                        else
                        {
                            o_Object.BIDON_DON = txt_BIDON.Text;
                            o_Object.NGUYENDON_DON = txt_NGUYENDON.Text;
                            o_Object.QHPL_DS_DON = txtQHPL.Text;

                        }
                    }

                }
                //Thong tin giao nhan don
                if (Drop_DVXULY_ID_DON.SelectedValue != "")
                    o_Object.DVXULY_ID_DON = Convert.ToDecimal(Drop_DVXULY_ID_DON.SelectedValue);
                if (Drop_CANBONHAN_ID.SelectedValue != "")
                    o_Object.CANBONHAN_ID = Convert.ToDecimal(Drop_CANBONHAN_ID.SelectedValue);
                if (txtNgaygiao.Text != "")
                    o_Object.NGAY_GIAO_DON = DateTime.Parse(this.txtNgaygiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                o_Object.NGUOI_TAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                VT_VANTHU_DEN_BL oBL = new VT_VANTHU_DEN_BL();
                if (oBL.VAN_BAN_DEN_INS_UP(o_Object) == true)
                {
                    if (Hi_update.Value == "")
                    {
                        lbtthongbao_popup.Text = "Bạn đã thêm mới thành công";
                        Hi_update.Value = string.Empty;
                       //Soden_Get_Values();
                    }
                    Load_Data();
                }
            }
            catch (Exception ex)
            {
                lbtthongbao_popup.Text = "Lỗi: " + ex.Message;
            }
        }
        private bool CheckData()
        {
            if (Drop_NGUONDEN.SelectedValue == "")
            {
                lbtthongbao_popup.Text = "Bạn chưa chọn nguồn đến";
                Cls_Comon.SetFocus(this.Drop_NGUONDEN, this.GetType(), Drop_NGUONDEN.ClientID);
                return false;
            }
            if (Drop_LOAI_VB.SelectedValue == "")
            {
                lbtthongbao_popup.Text = "Bạn chưa chọn loại văn bản";
                Cls_Comon.SetFocus(this.Drop_LOAI_VB, this.GetType(), Drop_LOAI_VB.ClientID);
                return false;
            }
            //if (txt_MABUUDIEN.Text.Trim() == "")
            //{
            //    if (Drop_NGUONDEN.SelectedValue == "1")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập mã bưu điện";
            //        Cls_Comon.SetFocus(this.txt_MABUUDIEN, this.GetType(), txt_MABUUDIEN.ClientID);
            //        return false;
            //    }
            //}
            //if (Drop_NOI_NHAN.SelectedValue == "")
            //{
            //    lbtthongbao_popup.Text = "Bạn chưa chọn đơn vị nhận";
            //    Cls_Comon.SetFocus(this.Drop_NOI_NHAN, this.GetType(), Drop_NOI_NHAN.ClientID);
            //    return false;
            //}
            //if (txt_SODEN.Text.Trim() == "")
            //{
            //    lbtthongbao_popup.Text = "Số đến trống bạn phải nhập số đến";
            //    Cls_Comon.SetFocus(this.txt_SODEN, this.GetType(), txt_SODEN.ClientID);
            //    return false;
            //}
            // if (txt_NGAY_DEN.Text.Trim() == "")
            //{
            //    lbtthongbao_popup.Text = "Bạn chưa nhập ngày đến";
            //    Cls_Comon.SetFocus(this.txt_NGAY_DEN, this.GetType(), txt_NGAY_DEN.ClientID);
            //    return false;
            //}
            // if (txt_NGAY_BT.Text.Trim() == "")
            //{
            //    if (Drop_NGUONDEN.SelectedValue == "1")
            //    {
            //        lbtthongbao_popup.Text = "Ngày trên dấu bưu điện";
            //        Cls_Comon.SetFocus(this.txt_NGAY_BT, this.GetType(), txt_NGAY_BT.ClientID);
            //        return false;
            //    }
            //    else
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Ngày ghi trên đơn";
            //        Cls_Comon.SetFocus(this.txt_NGAY_BT, this.GetType(), txt_NGAY_BT.ClientID);
            //        return false;
            //    }
            //}
            // if (txt_NGUOI_GUI_BT.Text.Trim() == "")
            //{
            //    lbtthongbao_popup.Text = "Bạn chưa nhập Người gửi/Đơn vị gửi";
            //    Cls_Comon.SetFocus(this.txt_NGUOI_GUI_BT, this.GetType(), txt_NGUOI_GUI_BT.ClientID);
            //    return false;
            //}
            // if (txt_DIACHI_GUI_BT.Text.Trim() == "")
            //{
            //    lbtthongbao_popup.Text = "Bạn chưa nhập Địa chỉ gửi";
            //    Cls_Comon.SetFocus(this.txt_DIACHI_GUI_BT, this.GetType(), txt_DIACHI_GUI_BT.ClientID);
            //    return false;
            //}
            //if (Drop_LOAI_VB.SelectedValue == "5")//"Văn bản hành chính,Tài liệu chung"
            //{
            //    if (txt_SO_VB.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Số văn bản";
            //        Cls_Comon.SetFocus(this.txt_SO_VB, this.GetType(), txt_SO_VB.ClientID);
            //        return false;
            //    }
            //     if (txt_NGAY_VB.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Ngày văn bản";
            //        Cls_Comon.SetFocus(this.txt_NGAY_VB, this.GetType(), txt_NGAY_VB.ClientID);
            //        return false;
            //    }
            //     if (txt_NOIDUNG_VB.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Nội dung trích yếu";
            //        Cls_Comon.SetFocus(this.txt_NOIDUNG_VB, this.GetType(), txt_NOIDUNG_VB.ClientID);
            //        return false;
            //    }
            //    if(rdb_LDTRA_RA.SelectedValue=="1")
            //    {
            //        if (txt_NGAYTRA_RA_VB.Text.Trim() == "")
            //        {
            //            lbtthongbao_popup.Text = "Bạn chưa nhập Ngày trả ra";
            //            Cls_Comon.SetFocus(this.txt_NGAYTRA_RA_VB, this.GetType(), txt_NGAYTRA_RA_VB.ClientID);
            //            return false;
            //        }
            //        if (txt_BUTPHE_LANHDAO_VB.Text.Trim() == "")
            //        {
            //            lbtthongbao_popup.Text = "Bạn chưa nhập Bút phê của lãnh đạo";
            //            Cls_Comon.SetFocus(this.txt_BUTPHE_LANHDAO_VB, this.GetType(), txt_BUTPHE_LANHDAO_VB.ClientID);
            //            return false;
            //        }
            //        if (txt_DONVI_GQ_VB.Text.Trim() == "")
            //        {
            //            lbtthongbao_popup.Text = "Bạn chưa nhập Người GQ/Đơn vị GQ";
            //            Cls_Comon.SetFocus(this.txt_DONVI_GQ_VB, this.GetType(), txt_DONVI_GQ_VB.ClientID);
            //            return false;
            //        }
            //    }
            //}
            // if (Drop_LOAI_VB.SelectedValue == "1")//"Đơn"
            //{
            //    if (txt_NGUOIDUNG_DON.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập người đứng đơn";
            //        Cls_Comon.SetFocus(this.txt_NGUOIDUNG_DON, this.GetType(), txt_NGUOIDUNG_DON.ClientID);
            //        return false;
            //    }
            //    else if (txt_DIACHI_NG_DUNGDON.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập địa chỉ người đứng đơn";
            //        Cls_Comon.SetFocus(this.txt_DIACHI_NG_DUNGDON, this.GetType(), txt_DIACHI_NG_DUNGDON.ClientID);
            //        return false;
            //    }
            //    else if (txt_SOLUONG_DON.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Số lượng đơn";
            //        Cls_Comon.SetFocus(this.txt_SOLUONG_DON, this.GetType(), txt_SOLUONG_DON.ClientID);
            //        return false;
            //    }
            //    if (rdb_BAQD_CHECK_DON.SelectedValue == "1")
            //    {
            //         if (Drop_LOAI_AN_DON.SelectedValue == "")
            //        {
            //            lbtthongbao_popup.Text = "Bạn chưa chọn Loại án";
            //            Cls_Comon.SetFocus(this.Drop_LOAI_AN_DON, this.GetType(), Drop_LOAI_AN_DON.ClientID);
            //            return false;
            //        }
            //         if (Drop_CAP_XX_DON.SelectedValue == "")
            //        {
            //            lbtthongbao_popup.Text = "Bạn chưa chọn Cấp xét xử";
            //            Cls_Comon.SetFocus(this.Drop_CAP_XX_DON, this.GetType(), Drop_CAP_XX_DON.ClientID);
            //            return false;
            //        }
            //         if (txt_SO_BAQD_DON.Text.Trim() == "")
            //        {
            //            lbtthongbao_popup.Text = "Bạn chưa nhập Số BA/QĐ";
            //            Cls_Comon.SetFocus(this.txt_SO_BAQD_DON, this.GetType(), txt_SO_BAQD_DON.ClientID);
            //            return false;
            //        }
            //         if (txt_NGAY_BAQD_DON.Text.Trim() == "")
            //        {
            //            lbtthongbao_popup.Text = "Bạn chưa nhập Ngày BA/QĐ";
            //            Cls_Comon.SetFocus(this.txt_NGAY_BAQD_DON, this.GetType(), txt_NGAY_BAQD_DON.ClientID);
            //            return false;
            //        }
            //         if (Drop_TOAAN_BAQD_DON.Text.Trim() == "")
            //        {
            //            lbtthongbao_popup.Text = "Bạn chưa chọn Tòa án ra BA/QĐ";
            //            Cls_Comon.SetFocus(this.Drop_TOAAN_BAQD_DON, this.GetType(), Drop_TOAAN_BAQD_DON.ClientID);
            //            return false;
            //        }
            //    }

            //}
            // if (Drop_LOAI_VB.SelectedValue == "2")//"Công văn"
            //{
            //    if (txt_SO_CV.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Số công văn";
            //        Cls_Comon.SetFocus(this.txt_SO_CV, this.GetType(), txt_SO_CV.ClientID);
            //        return false;
            //    }
            //     if (txt_NGAY_CV.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Ngày công văn";
            //        Cls_Comon.SetFocus(this.txt_NGAY_CV, this.GetType(), txt_NGAY_CV.ClientID);
            //        return false;
            //    }
            //     if (txt_DONVICHUYEN_CV.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Cơ quan/Đơn vị chuyển";
            //        Cls_Comon.SetFocus(this.txt_DONVICHUYEN_CV, this.GetType(), txt_DONVICHUYEN_CV.ClientID);
            //        return false;
            //    }
            //     if (txt_NOIDUNG_CV.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Nội dung";
            //        Cls_Comon.SetFocus(this.txt_NOIDUNG_CV, this.GetType(), txt_NOIDUNG_CV.ClientID);
            //        return false;
            //    }
            //}
            // if (Drop_LOAI_VB.SelectedValue == "3")//"Đơn + Công văn"
            //{
            //    if (txt_SO_CV.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Số công văn";
            //        Cls_Comon.SetFocus(this.txt_SO_CV, this.GetType(), txt_SO_CV.ClientID);
            //        return false;
            //    }
            //     if (txt_NGAY_CV.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Ngày công văn";
            //        Cls_Comon.SetFocus(this.txt_NGAY_CV, this.GetType(), txt_NGAY_CV.ClientID);
            //        return false;
            //    }
            //     if (txt_DONVICHUYEN_CV.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Cơ quan/Đơn vị chuyển";
            //        Cls_Comon.SetFocus(this.txt_DONVICHUYEN_CV, this.GetType(), txt_DONVICHUYEN_CV.ClientID);
            //        return false;
            //    }
            //     if (txt_NOIDUNG_CV.Text.Trim() == "")
            //    {
            //        lbtthongbao_popup.Text = "Bạn chưa nhập Nội dung";
            //        Cls_Comon.SetFocus(this.txt_NOIDUNG_CV, this.GetType(), txt_NOIDUNG_CV.ClientID);
            //        return false;
            //    }
            //}
            PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);
            CurrDonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PhongBanID).FirstOrDefault();

            if (CurrDonViID == 1 && obj.ISGIAIQUYETDON == 1)
            {

                if (Drop_LOAI_VB.SelectedValue == "4")//"Hồ sơ Kháng nghị GĐT,TT"
                {
                    if (txt_SODEN.Text.Trim() == "")
                    {
                        lbtthongbao_popup.Text = "Bạn chưa số đến (*)";
                        Cls_Comon.SetFocus(this.txt_SODEN, this.GetType(), txt_SODEN.ClientID);
                        return false;
                    }
                    if (txt_NGAY_DEN.Text.Trim() == "")
                    {
                        lbtthongbao_popup.Text = "Bạn chưa nhập ngày đến(*)";
                        Cls_Comon.SetFocus(this.txt_NGAY_DEN, this.GetType(), txt_NGAY_DEN.ClientID);
                        return false;
                    }
                    if (txtSOKN.Text.Trim() == "")
                    {
                        lbtthongbao_popup.Text = "Bạn chưa nhập QĐKN (*)";
                        Cls_Comon.SetFocus(this.txtSOKN, this.GetType(), txtSOKN.ClientID);
                        return false;
                    }
                    else if (txt_NGAYQDKN.Text.Trim() == "")
                    {
                        lbtthongbao_popup.Text = "Bạn chưa nhập Ngày QĐKN (*)";
                        Cls_Comon.SetFocus(this.txt_NGAYQDKN, this.GetType(), txt_NGAYQDKN.ClientID);
                        return false;
                    }
                    if (dropVKS_NguoiKy.SelectedValue == "0")
                    {
                        lbtthongbao_popup.Text = "Bạn chưa chọn Người Kháng nghị (*)";
                        Cls_Comon.SetFocus(this.dropVKS_NguoiKy, this.GetType(), dropVKS_NguoiKy.ClientID);
                        return false;
                    }
                    if (drop_LoaiGDT.SelectedValue == "0")
                    {
                        lbtthongbao_popup.Text = "Bạn chưa chọn Kháng nghị theo thủ tục (*)";
                        Cls_Comon.SetFocus(this.dropVKS_NguoiKy, this.GetType(), dropVKS_NguoiKy.ClientID);
                        return false;
                    }
                    if (rdb_BAQD_CHECK.SelectedValue == "1")
                    {
                        if (txt_SO_BAQD_DON.Text.Trim() == "")
                        {
                            lbtthongbao_popup.Text = "Bạn chưa nhập Số BA/QĐ (*)";
                            Cls_Comon.SetFocus(this.txt_SO_BAQD_DON, this.GetType(), txt_SO_BAQD_DON.ClientID);
                            return false;
                        }
                        if (txt_NGAY_BAQD_DON.Text.Trim() == "")
                        {
                            lbtthongbao_popup.Text = "Bạn chưa nhập Ngày BA/QĐ (*)";
                            Cls_Comon.SetFocus(this.txt_NGAY_BAQD_DON, this.GetType(), txt_NGAY_BAQD_DON.ClientID);
                            return false;
                        }
                        if (Drop_TOAAN_BAQD_DON.Text.Trim() == "0")
                        {
                            lbtthongbao_popup.Text = "Bạn chưa chọn Tòa án ra BA/QĐ (*)";
                            Cls_Comon.SetFocus(this.Drop_TOAAN_BAQD_DON, this.GetType(), Drop_TOAAN_BAQD_DON.ClientID);
                            return false;
                        }
                        if (Drop_CAP_XX_DON.SelectedValue == "0")
                        {
                            lbtthongbao_popup.Text = "Bạn chưa chọn Cấp xét xử (*)";
                            Cls_Comon.SetFocus(this.Drop_CAP_XX_DON, this.GetType(), Drop_CAP_XX_DON.ClientID);
                            return false;
                        }
                        if (Drop_LOAI_AN_DON.SelectedValue == "0")
                        {
                            lbtthongbao_popup.Text = "Bạn chưa chọn Loại án (*)";
                            Cls_Comon.SetFocus(this.Drop_LOAI_AN_DON, this.GetType(), Drop_LOAI_AN_DON.ClientID);
                            return false;
                        }
                    }
                }
            }
            return true;
        }
        private void Display_validate()
        {
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PhongBanID).FirstOrDefault();
            if (CurrDonViID == 1 && obj.ISGIAIQUYETDON == 1 )
            {

                if (Drop_LOAI_VB.SelectedValue == "4")//"Hồ sơ Kháng nghị GĐT,TT"
                {
                    id_span_txtSOKN.Style.Add("remove","display");
                    id_span_txt_NGAYQDKN.Style.Add("remove", "display");
                    id_span_dropVKS_NguoiKy.Style.Add("remove", "display");
           
                    id_span_drop_LoaiGDT.Style.Add("remove", "display");
                    id_span_txt_SO_BAQD_DON.Style.Add("remove", "display");
                    id_span_txt_NGAY_BAQD_DON.Style.Add("remove", "display");
                    id_span_Drop_TOAAN_BAQD_DON.Style.Add("remove", "display");
                    id_span_Drop_CAP_XX_DON.Style.Add("remove", "display");
                    id_span_Drop_LOAI_AN_DON.Style.Add("remove", "display");
                }
            }
            else
            {
                id_span_txtSOKN.Style.Add("display", "none");
                id_span_txt_NGAYQDKN.Style.Add("display", "none");
                id_span_dropVKS_NguoiKy.Style.Add("display", "none");

                id_span_drop_LoaiGDT.Style.Add("display", "none");
                id_span_txt_SO_BAQD_DON.Style.Add("display", "none");
                id_span_txt_NGAY_BAQD_DON.Style.Add("display", "none");
                id_span_Drop_TOAAN_BAQD_DON.Style.Add("display", "none");
                id_span_Drop_CAP_XX_DON.Style.Add("display", "none");
                id_span_Drop_LOAI_AN_DON.Style.Add("display", "none");
            }
        }
        protected void cmdLammoi_popup_Click(object sender, EventArgs e)
        {
            Hi_update.Value = string.Empty;
            lbtthongbao_popup.Text = string.Empty;
            clear_value();
        }
        public void clear_value()
        {
            //Drop_LOAI_VB.SelectedValue = string.Empty;
            //LoaiVB_Load();
            //Soden_Get_Values();
            txt_SODEN.Text = string.Empty;
            //Drop_NOI_NHAN.SelectedValue = "0";
            Drop_NGUOI_NHAN.SelectedValue = "0";
            txt_NGAY_DEN.Text = string.Empty;
            txt_NGUOI_GUI_BT.Text = string.Empty;
            txt_DIACHI_GUI_BT.Text = string.Empty;
            txt_NGAY_BT.Text = string.Empty;
            txt_GHICHU.Text = string.Empty;
            Drop_NGUONDEN.SelectedValue = "0";
            txt_MABUUDIEN.Text = string.Empty;
            txt_SOLUONG_GAM.Text = string.Empty;
            //VB
            drop_DOMAT.Text = string.Empty;
            drop_DOKHAN.Text = string.Empty;
            txt_SO_VB.Text = string.Empty;
            txt_NGAY_VB.Text = string.Empty;
            txt_NOIDUNG_VB.Text = string.Empty;
            rdb_LDTRA_RA.SelectedValue = "0";
            txt_NGAYTRA_RA_VB.Text = string.Empty;
            txt_BUTPHE_LANHDAO_VB.Text = string.Empty;
            txt_DONVI_GQ_VB.Text = string.Empty;
            Check_Display_LDTRA_RA();
            //---- 
            txt_NGUOIDUNG_DON.Text = string.Empty;
            txt_DIACHI_NG_DUNGDON.Text = string.Empty;
            txt_SOLUONG_DON.Text = string.Empty;

            drop_LoaiGDT.SelectedValue = "0";
            rdb_BAQD_CHECK.SelectedValue = "1";
            if (Drop_LOAI_AN_DON.Items.FindByValue("0") != null)
            {
                Drop_LOAI_AN_DON.SelectedValue = "0";
            }
            Drop_CAP_XX_DON.SelectedValue = "0";
            txt_SO_BAQD_DON.Text = string.Empty;
            txt_NGAY_BAQD_DON.Text = string.Empty;
            Drop_TOAAN_BAQD_DON.SelectedValue = "0";
            txt_SO_CV.Text = string.Empty;
            txt_NGAY_CV.Text = string.Empty;
            txt_DONVICHUYEN_CV.Text = string.Empty;
            txt_NOIDUNG_CV.Text = string.Empty;
            //Drop_DVXULY_ID_DON.SelectedValue = "0";
            CAN_BO_Load(CurrDonViID + "", Drop_DVXULY_ID_DON.SelectedValue);
            Drop_CANBONHAN_ID.SelectedValue = "0";
            txtNgaygiao.Text = string.Empty;
            //hoso
            //Drop_LOAI_AN_HOSO.SelectedValue = string.Empty;
            LOAI_AN_HOSO_CHECK();
            txtSOKN.Text = string.Empty;
            txt_NGAYQDKN.Text = string.Empty;

            txt_NGUYENDON.Text = string.Empty;
            txt_BIDON.Text = string.Empty;
            txtQHPL.Text = string.Empty;
            txt_BICAO_HS.Text = string.Empty;
            Drop_QHPL.SelectedValue = "0";

            dropVKS_NguoiKy.SelectedValue = "0";
            txt_GHICHU_HS.Text = string.Empty;

            ddl_DIACHI_NDD_ID.SelectedValue = "0";
            ddl_DIACHI_GUI_BT_ID.SelectedValue = "0";
        }
        void LoadAllLoaiAn()
        {
            VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
            DataTable objs = obj_M.LOAI_AN_LIST();
            Drop_LOAI_AN_DON.DataSource = objs;
            Drop_LOAI_AN_DON.DataTextField = "LOAI_AN_TEN";
            Drop_LOAI_AN_DON.DataValueField = "ID";
            Drop_LOAI_AN_DON.DataBind();
            Drop_LOAI_AN_DON.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        void LoadAllLoaiAn_Search()
        {
            VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
            DataTable objs = obj_M.LOAI_AN_LIST();
            Drop_LOAI_AN_DON_SEARCH.DataSource = objs;
            Drop_LOAI_AN_DON_SEARCH.DataTextField = "LOAI_AN_TEN";
            Drop_LOAI_AN_DON_SEARCH.DataValueField = "ID";
            Drop_LOAI_AN_DON_SEARCH.DataBind();
            Drop_LOAI_AN_DON_SEARCH.Items.Insert(0, new ListItem("---Chọn---", ""));
            Drop_LOAI_AN_DON_SEARCH.Items.Insert(8, new ListItem("Chưa xác định", "55"));
        }
        //void LoadAllLoaiAn_hs()
        //{
        //    VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
        //    DataTable objs = obj_M.LOAI_AN_LIST();
        //    Drop_LOAI_AN_HOSO.DataSource = objs;
        //    Drop_LOAI_AN_HOSO.DataTextField = "LOAI_AN_TEN";
        //    Drop_LOAI_AN_HOSO.DataValueField = "ID";
        //    Drop_LOAI_AN_HOSO.DataBind();
        //    Drop_LOAI_AN_HOSO.Items.Insert(0, new ListItem("---Chọn---", ""));
        //}
        void QuanHePL_hs()
        {
            if (Drop_LOAI_AN_DON.SelectedValue != "")
            {
                if (Drop_LOAI_AN_DON.SelectedValue == "1")
                {
                    Drop_QHPL.Items.Clear();
                    GDTTT_APP_BL oBL = new GDTTT_APP_BL();
                    DataTable tbl = new DataTable();
                    //-------------
                    tbl = oBL.DieuLuat_ToiDanh_Thongke();
                    Drop_QHPL.DataSource = tbl;
                    Drop_QHPL.DataTextField = "TENTOIDANH";
                    Drop_QHPL.DataValueField = "ID";
                    Drop_QHPL.DataBind();
                    Drop_QHPL.Items.Insert(0, new ListItem("Chọn", "0"));
                }
                else
                {
                    String StrLoaiAn = "", loai_an_name = ""; ; int LoaiAn = Convert.ToInt32(Drop_LOAI_AN_DON.SelectedValue);
                    if (LoaiAn < 10)
                        StrLoaiAn = "0" + LoaiAn.ToString();
                    switch (StrLoaiAn)
                    {
                        case ENUM_LOAIVUVIEC.AN_HINHSU:
                            LoaiAn = 1; loai_an_name = "HINH_SU";
                            break;
                        case ENUM_LOAIVUVIEC.AN_DANSU:
                            LoaiAn = 0;
                            break;
                        case ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH:
                            LoaiAn = 1;
                            break;
                        case ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI:
                            LoaiAn = 2;
                            break;
                        case ENUM_LOAIVUVIEC.AN_LAODONG:
                            LoaiAn = 3;
                            break;
                        case ENUM_LOAIVUVIEC.AN_HANHCHINH:
                            LoaiAn = 4;
                            break;
                        case ENUM_LOAIVUVIEC.AN_PHASAN:
                            LoaiAn = 5;
                            break;
                    }
                    DM_QHPL_TK_BL objBL = new DM_QHPL_TK_BL();
                    DataTable tblQHPLTK = objBL.GDTTT_QHPL_TK_GetByLoaiAn(2, LoaiAn, loai_an_name);
                    if (tblQHPLTK != null && tblQHPLTK.Rows.Count > 0)
                    {
                        Drop_QHPL.Items.Clear();
                        Drop_QHPL.DataSource = tblQHPLTK;
                        Drop_QHPL.DataTextField = "TenToiDanh";
                        Drop_QHPL.DataValueField = "ID";
                        Drop_QHPL.DataBind();
                        Drop_QHPL.Items.Insert(0, new ListItem("Chọn", "0"));
                    }
                }
            }
            else
            {
                Drop_QHPL.Items.Clear();
                Drop_QHPL.Items.Insert(0, new ListItem("---Chọn---", "0"));
            }
        }
        private void Load_Capxx()
        {
            Drop_CAP_XX_DON.Items.Clear();
            Drop_CAP_XX_DON.Items.Add(new ListItem("--Chọn--", "0"));
            Drop_CAP_XX_DON.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            Drop_CAP_XX_DON.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            Drop_CAP_XX_DON.Items.Add(new ListItem("Giám đốc thẩm, Tái thẩm", ENUM_GIAIDOANVUAN.THULYGDT.ToString()));
        }
        protected void rdb_BAQD_CHECK_SelectedIndexChanged(object sender, EventArgs e)
        {
            BA_QD_Load();
        }
        protected void rdb_LDTRA_RA_SelectedIndexChanged(object sender, EventArgs e)
        {
            Check_Display_LDTRA_RA();
        }
        void Check_Display_LDTRA_RA()
        {
            if (rdb_LDTRA_RA.SelectedValue == "0")
            {
                div_LANHDAOTRA_RA.Style.Add("Display", "none");
            }
            else if (rdb_LDTRA_RA.SelectedValue == "1")
            {
                div_LANHDAOTRA_RA.Style.Add("Display", "block");
            }

        } 
        protected void BA_QD_Load()
        {
            if (rdb_BAQD_CHECK.SelectedValue == "0")
            {
                div_BA_QD.Style.Add("Display", "none");
                div_DANSU_EXT.Style.Add("Display", "none");
                div_HINHSU.Style.Add("Display", "none");
                div_QHPL.Style.Add("Display", "none");
                div_QHPL_DS.Style.Add("Display", "none");
            }
            else
            {
                div_BA_QD.Style.Add("Display", "block");
            }
        }
        protected void Drop_LOAI_VB_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoaiVB_Load();
            DONVI_GQ_Load();
            LanhDao_Load(CurrDonViID + "");
            if (Drop_LOAI_VB.SelectedValue == "4")
            {
                lblInforBA.Text = "Thông tin Bản án/Quyết định bị Kháng nghị";
                lblLoaiDeNghi.Text = "Kháng nghị theo thủ tục";
            }
            else
            {
                lblInforBA.Text = "Thông tin Bản án/Quyết định";
                lblLoaiDeNghi.Text = "Đề nghị theo thủ tục";
            }
            DM_PHONGBAN obj = dt.DM_PHONGBAN.Where(x => x.ID == PhongBanID).FirstOrDefault();
            if (Drop_LOAI_VB.SelectedValue != "5" && Drop_LOAI_VB.SelectedValue != "")
            {
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "1")//Tòa án nhân dân tối cao
                {
                    if (obj.ISGIAIQUYETDON == 1)
                    {
                        Drop_NOI_NHAN.SelectedValue = PhongBanID.ToString();
                    }
                } 
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "4")//Tòa án nhân dân cấp cao tại Hà Nội
                    Drop_NOI_NHAN.SelectedValue = "5";//mặc định sẽ là văn phòng nhận
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "5")//Tòa án nhân dân cấp cao tại Đà Nẵng
                    Drop_NOI_NHAN.SelectedValue = "9";//mặc định sẽ là văn phòng nhận
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "6")//Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh
                    Drop_NOI_NHAN.SelectedValue = "13";//mặc định sẽ là văn phòng nhận
                Drop_NOI_NHAN.Enabled = false;
            }
            else if(Drop_LOAI_VB.SelectedValue == "")
            {
                Drop_NOI_NHAN.Enabled = true;
                div_NGUOI_NHAN.Style.Add("Display", "none");
            }
            else
            {
                Drop_NOI_NHAN.Enabled = true;
            }
            //Soden_Get_Values();
            Check_Display_LDTRA_RA();
            

        }
        protected void Drop_NGUONDEN_SelectedIndexChanged(object sender, EventArgs e)
        {
            CHECKBY_NGUONDEN();
        }
        void CHECKBY_NGUONDEN()
        {
            if(Drop_NGUONDEN.SelectedValue=="1")
            {
                lbl_NGAY_BT_NAME.Text = "Ngày trên dấu bưu điện";
                div_MABUUDIEN.Style.Add("Display","block");
            }
            else
            {
                lbl_NGAY_BT_NAME.Text = "Ngày ghi trên đơn";
                div_MABUUDIEN.Style.Add("Display", "none");
            }
        }
        protected void Drop_LOAI_AN_DON_SelectedIndexChanged(object sender, EventArgs e)
        {
            QuanHePL_hs();
            LOAI_AN_HOSO_CHECK();
        }
        void LOAI_AN_HOSO_CHECK()
        {
            if(Drop_LOAI_AN_DON.SelectedValue=="1")
            {
                div_DANSU_EXT.Style.Add("Display","none");
                div_QHPL_DS.Style.Add("Display", "none");
                div_HINHSU.Style.Add("Display", "block");
                div_QHPL.Style.Add("Display", "block");
                
            }
            else if (Drop_LOAI_AN_DON.SelectedValue == "0")
            {
                div_DANSU_EXT.Style.Add("Display", "none");
                div_QHPL_DS.Style.Add("Display", "none");
                div_HINHSU.Style.Add("Display", "none");
                div_QHPL.Style.Add("Display", "none");
            }
            else
            {
                div_DANSU_EXT.Style.Add("Display", "block");
                div_QHPL_DS.Style.Add("Display", "block");
                div_HINHSU.Style.Add("Display", "none");
                div_QHPL.Style.Add("Display", "none");
            }
        }
        protected void Drop_NOI_NHAN_SelectedIndexChanged(object sender, EventArgs e)
        {
            DONVI_GQ_Load();
            //if (Drop_NOI_NHAN.SelectedValue == "13")
            //{
            //    Drop_DVXULY_ID_DON.Enabled = true;
            //    Drop_DVXULY_ID_DON.SelectedValue = "0";
            //}
            //else
            //{
            //    Drop_DVXULY_ID_DON.Enabled = false;
            //    Drop_DVXULY_ID_DON.SelectedValue = Drop_NOI_NHAN.SelectedValue;
            //}
        }
        protected void Drop_NOI_NHAN_SEARCH_SelectedIndexChanged(object sender, EventArgs e)
        {
            LanhDao_Load_Search(CurrDonViID + "");
        }
        protected void LoaiVB_Load()
        {
            if (Drop_LOAI_VB.SelectedValue == "")
            {
                div_vbhc.Style.Add("Display", "none");
                div_don.Style.Add("Display", "none");
                div_Don_CV.Style.Add("Display", "none");
                div_VKS.Style.Add("Display", "none");
                div_BAQD.Style.Add("Display", "none");
                div_SOLUONG_GAM.Style.Add("Display", "none");
                lblGhiChu.Text = "Ghi chú";
            }
            else if (Drop_LOAI_VB.SelectedValue == "5")//Văn bản hành chính
            {
                div_vbhc.Style.Add("Display", "block");
                div_don.Style.Add("Display", "none");
                div_Don_CV.Style.Add("Display", "none");
                div_VKS.Style.Add("Display", "none");
                div_BAQD.Style.Add("Display", "none");
                div_NGUOI_NHAN.Style.Add("Display", "block");
                div_SOLUONG_GAM.Style.Add("Display", "none");
                lblGhiChu.Text = "Ghi chú";
            }
            else if (Drop_LOAI_VB.SelectedValue == "1")//Đơn
            {
                div_vbhc.Style.Add("Display", "none");
                div_don.Style.Add("Display", "block");
                div_Don_CV.Style.Add("Display", "none");
                div_VKS.Style.Add("Display", "none");
                div_BA_QD.Style.Add("Display", "block");
                div_BAQD.Style.Add("Display", "block");
                div_NGUOI_NHAN.Style.Add("Display", "none");
                div_SOLUONG_GAM.Style.Add("Display", "none");
                lblGhiChu.Text = "Ghi chú";
            }
            else if (Drop_LOAI_VB.SelectedValue == "2")// CV
            {
                div_vbhc.Style.Add("Display", "none");
                div_don.Style.Add("Display", "none");
                div_Don_CV.Style.Add("Display", "block");
                div_VKS.Style.Add("Display", "none");
                div_BA_QD.Style.Add("Display", "block");
                div_BAQD.Style.Add("Display", "none");
                div_NGUOI_NHAN.Style.Add("Display", "none");
                div_SOLUONG_GAM.Style.Add("Display", "none");
                lbl_loaiCV.Text = "Công văn chuyển đơn";
                lblGhiChu.Text = "Ghi chú";
            }
            else if (Drop_LOAI_VB.SelectedValue == "3")//Đơn + CV
            {
                div_vbhc.Style.Add("Display", "none"); 
                div_don.Style.Add("Display", "block");
                div_Don_CV.Style.Add("Display", "block");
                div_VKS.Style.Add("Display", "none");
                div_BA_QD.Style.Add("Display", "block");
                div_BAQD.Style.Add("Display", "block");
                div_NGUOI_NHAN.Style.Add("Display", "none");
                div_SOLUONG_GAM.Style.Add("Display", "none");
                lbl_loaiCV.Text = "Công văn chuyển đơn";
                lblGhiChu.Text = "Ghi chú";
            }
            else if (Drop_LOAI_VB.SelectedValue == "4")//Hồ sơ
            {
                div_vbhc.Style.Add("Display", "none");
                div_don.Style.Add("Display", "none");
                div_Don_CV.Style.Add("Display", "none");
                div_VKS.Style.Add("Display", "block");
                div_BA_QD.Style.Add("Display", "block");
                div_BAQD.Style.Add("Display", "block");
                div_NGUOI_NHAN.Style.Add("Display", "none");
                div_SOLUONG_GAM.Style.Add("Display", "block");
                lblGhiChu.Text = "Ghi chú";
            }
            else if (Drop_LOAI_VB.SelectedValue == "6")//Cong van kien nghi
            {
                div_vbhc.Style.Add("Display", "none");
                div_don.Style.Add("Display", "none");
                div_Don_CV.Style.Add("Display", "block");
                div_VKS.Style.Add("Display", "none");
                div_BA_QD.Style.Add("Display", "block");
                div_BAQD.Style.Add("Display", "block");
                div_NGUOI_NHAN.Style.Add("Display", "none");
                div_SOLUONG_GAM.Style.Add("Display", "none");
                lbl_loaiCV.Text = "Thông tin Công văn kiến nghị";
                lblGhiChu.Text = "Ghi chú";
            }
            else if (Drop_LOAI_VB.SelectedValue == "9")//Cong van kien nghi + CV chuyển đơn
            {
                div_vbhc.Style.Add("Display", "none");
                div_don.Style.Add("Display", "none");
                div_Don_CV.Style.Add("Display", "block");
                div_VKS.Style.Add("Display", "none");
                div_BA_QD.Style.Add("Display", "block");
                div_BAQD.Style.Add("Display", "block");
                div_NGUOI_NHAN.Style.Add("Display", "none");
                div_SOLUONG_GAM.Style.Add("Display", "block");
                lbl_loaiCV.Text = "Thông tin Công văn kiến nghị";
                lblGhiChu.Text = "Ghi chú";
            }
            else if (Drop_LOAI_VB.SelectedValue == "7")//Thông báo phát hiện vi phạm pháp luật
            {
                div_vbhc.Style.Add("Display", "none");
                div_don.Style.Add("Display", "none");
                div_Don_CV.Style.Add("Display", "none");
                div_VKS.Style.Add("Display", "none");
                div_BA_QD.Style.Add("Display", "none");
                div_BAQD.Style.Add("Display", "none");
                div_NGUOI_NHAN.Style.Add("Display", "none");
                div_SOLUONG_GAM.Style.Add("Display", "none");
                lblGhiChu.Text = "Nội dung";
            }
            else if (Drop_LOAI_VB.SelectedValue == "8")//Đơn khiếu nại tư pháp
            {
                div_vbhc.Style.Add("Display", "none");
                div_don.Style.Add("Display", "none");
                div_Don_CV.Style.Add("Display", "none");
                div_VKS.Style.Add("Display", "none");
                div_BA_QD.Style.Add("Display", "none");
                div_BAQD.Style.Add("Display", "none");
                div_NGUOI_NHAN.Style.Add("Display", "none");
                div_SOLUONG_GAM.Style.Add("Display", "none");
                lblGhiChu.Text = "Nội dung";
            }
            div_NGUOI_NHAN.Style.Add("Display", "block");
        }
        protected void DONVI_GQ_Load()
        {
            String pb = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            String cxx = Session["CAP_XET_XU"] + "";
            //TOICAO
            Drop_DVXULY_ID_DON.Items.Clear();
            if (cxx == "TOICAO")
            {
                VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
                DataTable objs = obj_M.PHONG_BAN_LIST(CurrDonViID + "", null, "1");
                Drop_DVXULY_ID_DON.DataSource = objs;
                Drop_DVXULY_ID_DON.DataTextField = "TENPHONGBAN";
                Drop_DVXULY_ID_DON.DataValueField = "ID";
                Drop_DVXULY_ID_DON.DataBind();
                Drop_DVXULY_ID_DON.Enabled = false;
                Drop_DVXULY_ID_DON.SelectedValue = "280";
            }
            else
            {
                if (Drop_LOAI_VB.SelectedValue == "5")
                {
                    if (Drop_NOI_NHAN.SelectedValue == "13" || Drop_NOI_NHAN.SelectedValue == "9" || Drop_NOI_NHAN.SelectedValue == "5")
                    {
                        ListItem ites = new ListItem();
                        ites = new ListItem("---Chọn--", "0");
                        Drop_DVXULY_ID_DON.Items.Add(ites);
                        ites = new ListItem("Phòng hành chính tư pháp", pb);
                        Drop_DVXULY_ID_DON.Items.Add(ites);
                        Drop_DVXULY_ID_DON.Enabled = true;
                    }
                    else
                    {
                        VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
                        DataTable objs = obj_M.PHONG_BAN_LIST(CurrDonViID + "", null, "2");
                        Drop_DVXULY_ID_DON.DataSource = objs;
                        Drop_DVXULY_ID_DON.DataTextField = "TENPHONGBAN";
                        Drop_DVXULY_ID_DON.DataValueField = "ID";
                        Drop_DVXULY_ID_DON.DataBind();
                        Drop_DVXULY_ID_DON.Items.Insert(0, new ListItem("---Chọn---", "0"));
                        Drop_DVXULY_ID_DON.Enabled = false;
                        Drop_DVXULY_ID_DON.SelectedValue = Drop_NOI_NHAN.SelectedValue;
                    }
                }
                else
                {
                    //ListItem ites = new ListItem();
                    //ites = new ListItem("---Chọn--", "0");
                    //Drop_DVXULY_ID_DON.Items.Add(ites);
                    //ites = new ListItem("Phòng hành chính tư pháp", pb);
                    //Drop_DVXULY_ID_DON.Items.Add(ites);
                    /////////
                    //Drop_DVXULY_ID_DON.Enabled = false;
                    //Drop_DVXULY_ID_DON.SelectedValue = pb;
                    VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
                    DataTable objs = obj_M.PHONG_BAN_LIST(CurrDonViID + "", null, "2");
                    Drop_DVXULY_ID_DON.DataSource = objs;
                    Drop_DVXULY_ID_DON.DataTextField = "TENPHONGBAN";
                    Drop_DVXULY_ID_DON.DataValueField = "ID";
                    Drop_DVXULY_ID_DON.DataBind();
                    Drop_DVXULY_ID_DON.Items.Insert(0, new ListItem("---Chọn---", "0"));
                    Drop_DVXULY_ID_DON.Enabled = false;
                    Drop_DVXULY_ID_DON.SelectedValue = Drop_NOI_NHAN.SelectedValue;
                }
            }
            //if (Drop_LOAI_VB.SelectedValue == "2")// CV
            //{
            //    ites = new ListItem("---Chọn--", "0");
            //    Drop_DVXULY_ID_DON.Items.Add(ites);
            //    ites = new ListItem("Phòng hành chính tư pháp", "1");
            //    Drop_DVXULY_ID_DON.Items.Add(ites);
            //    ////////////////
            //    Drop_DVXULY_ID_DON.Enabled = true;
            //}
            //else if (Drop_LOAI_VB.SelectedValue == "3")//Đơn + CV
            //{
            //    ites = new ListItem("---Chọn--", "0");
            //    Drop_DVXULY_ID_DON.Items.Add(ites);
            //    ites = new ListItem("Phòng hành chính tư pháp", "1");
            //    Drop_DVXULY_ID_DON.Items.Add(ites);
            //    ///////
            //    Drop_DVXULY_ID_DON.Enabled = false;
            //    Drop_DVXULY_ID_DON.SelectedValue = "1";
            //}
        }
        private void NoiNhan_Load(string vDonVi)
        {
            VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
            DataTable objs = obj_M.PHONG_BAN_LIST(vDonVi, null, "1");
            Drop_NOI_NHAN.DataSource = objs;
            Drop_NOI_NHAN.DataTextField = "TENPHONGBAN";
            Drop_NOI_NHAN.DataValueField = "ID";
            Drop_NOI_NHAN.DataBind();
            Drop_NOI_NHAN.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void NoiNhan_Load_Search()
        {
            String pb = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.TAOMOI == true)
            { 
                    pb = "";
            }
            if (pb == "13" || pb == "9" || pb == "5")
            {
                ///-----
                ListItem ites = new ListItem();
                Drop_NOI_NHAN_SEARCH.Items.Clear();
                ites = new ListItem("Văn phòng TANDCC", pb);
                Drop_NOI_NHAN_SEARCH.Items.Add(ites);
            }
            else
            {
                VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
                DataTable objs = obj_M.PHONG_BAN_LIST(Session[ENUM_SESSION.SESSION_DONVIID] + "", null, "1");
                Drop_NOI_NHAN_SEARCH.DataSource = objs;
                Drop_NOI_NHAN_SEARCH.DataTextField = "TENPHONGBAN";
                Drop_NOI_NHAN_SEARCH.DataValueField = "ID";
                Drop_NOI_NHAN_SEARCH.DataBind();
                Drop_NOI_NHAN_SEARCH.Items.Insert(0, new ListItem("---Tất cả---", ""));
                Drop_NOI_NHAN_SEARCH.Items.Insert(1, new ListItem("Chưa xác định", "0"));
            }
        }
        private void LanhDao_Load(string Donvi)
        {
            Drop_NGUOI_NHAN.Items.Clear();
            VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
            DataTable objs = obj_M.CANBO_LIST_BY_PHONGBAN(Donvi, "");
            Drop_NGUOI_NHAN.DataSource = objs;
            Drop_NGUOI_NHAN.DataTextField = "HOTEN";
            Drop_NGUOI_NHAN.DataValueField = "ID";
            Drop_NGUOI_NHAN.DataBind();
            Drop_NGUOI_NHAN.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void CAN_BO_Load(string Donvi, string PhongBan)
        {
            Drop_CANBONHAN_ID.Items.Clear();
            VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
            DataTable objs = obj_M.CANBO_LIST_BY_PHONGBAN(Donvi, PhongBan);
            Drop_CANBONHAN_ID.DataSource = objs;
            Drop_CANBONHAN_ID.DataTextField = "HOTEN";
            Drop_CANBONHAN_ID.DataValueField = "ID";
            Drop_CANBONHAN_ID.DataBind();
            Drop_CANBONHAN_ID.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void LanhDao_Load_Search(string Donvi)
        {
            Drop_NGUOI_NHAN_SEARCH.Items.Clear();
            VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
            DataTable objs = obj_M.LANHDAO_LIST(Donvi, Drop_NOI_NHAN_SEARCH.SelectedValue);
            Drop_NGUOI_NHAN_SEARCH.DataSource = objs;
            Drop_NGUOI_NHAN_SEARCH.DataTextField = "HOTEN";
            Drop_NGUOI_NHAN_SEARCH.DataValueField = "ID";
            Drop_NGUOI_NHAN_SEARCH.DataBind();
            Drop_NGUOI_NHAN_SEARCH.Items.Insert(0, new ListItem("---Chọn---", ""));
        }
        private void Toa_an_ra_BAQD_Load()
        {
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA2 = oTABL.DM_TOAAN_GETBYNOTCUR(0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            Drop_TOAAN_BAQD_DON.DataSource = dtTA2;
            Drop_TOAAN_BAQD_DON.DataTextField = "MA_TEN";
            Drop_TOAAN_BAQD_DON.DataValueField = "ID";
            Drop_TOAAN_BAQD_DON.DataBind();
            Drop_TOAAN_BAQD_DON.Items.Insert(0, new ListItem("---Chọn---", "0"));
        }
        private void Toa_an_ra_BAQD_Load_Search()
        {
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA2 = oTABL.DM_TOAAN_GETBYNOTCUR(0, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            Drop_TOAAN_BAQD_DON_SEARCH.DataSource = dtTA2;
            Drop_TOAAN_BAQD_DON_SEARCH.DataTextField = "MA_TEN";
            Drop_TOAAN_BAQD_DON_SEARCH.DataValueField = "ID";
            Drop_TOAAN_BAQD_DON_SEARCH.DataBind();
            Drop_TOAAN_BAQD_DON_SEARCH.Items.Insert(0, new ListItem("---Chọn---", ""));
        }
        public void Soden_Get_Values()
        {
            VT_VANTHU_DEN_BL M_Object = new VT_VANTHU_DEN_BL();
            Int32 number_to = 0;
           String _PHONGBANID = "";
            M_Object.SODEN_RETURN(Session[ENUM_SESSION.SESSION_DONVIID] + "", _PHONGBANID, Drop_LOAI_VB.SelectedValue, ref number_to);
            txt_SODEN.Text = Convert.ToString(number_to);
        }
        #endregion
        #region "Danh sach"
        protected void cmdNhanan_Click(object sender, EventArgs e)
        {
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    String _Id = Item.Cells[1].Text;
                    VT_CHUYEN_NHAN o_Object = new VT_CHUYEN_NHAN();
                    VT_CHUYEN_NHAN_BL M_Object = new VT_CHUYEN_NHAN_BL();
                    o_Object.VANBANDEN_ID = Convert.ToDecimal(_Id);
                    o_Object.CANBO_NHAN_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
                    o_Object.USERNAME_NHAN = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    M_Object.VT_NHAN_INS_UP(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + ""), o_Object);
                    lbtthongbao.Text = "Bạn đã nhận thành công";
                }
            }
            Load_Data();
        }
        protected void cmdHuyNhan_Click(object sender, EventArgs e)
        {
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    String _Id = Item.Cells[1].Text;
                    VT_CHUYEN_NHAN o_Object = new VT_CHUYEN_NHAN();
                    VT_CHUYEN_NHAN_BL M_Object = new VT_CHUYEN_NHAN_BL();
                    string V_TRANG_THAI_XLY = "";
                    M_Object.VT_HUY_NHAN(_Id,ref V_TRANG_THAI_XLY);
                    if (V_TRANG_THAI_XLY == "3")
                    {
                        lbtthongbao.Text = "Bạn đã hủy nhận thành công";
                    }
                    else if (V_TRANG_THAI_XLY == "4")
                    {
                        lbtthongbao.Text = "Bạn không thể thu hồi bản ghi này, đơn vị nhận đã xử lý bản ghi này, để thu hồi được bạn phải xóa đơn đã xử lý ở Hành chính tư pháp";
                    }
                }
            }
            Load_Data();
        }
        protected void cmdChuyen_Click(object sender, EventArgs e)
        {
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    String _Id = Item.Cells[1].Text;
                    VT_CHUYEN_NHAN o_Object = new VT_CHUYEN_NHAN();
                    VT_CHUYEN_NHAN_BL M_Object = new VT_CHUYEN_NHAN_BL();
                    o_Object.VANBANDEN_ID = Convert.ToDecimal(_Id);
                    o_Object.DONVI_CHUYEN_ID =Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                    o_Object.CANBO_CHUYEN_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
                    M_Object.VT_CHUYEN_INS(o_Object);
                    lbtthongbao.Text = "Bạn đã chuyển thành công";
                }
            }
            Load_Data();
        }
        protected void cmdHuychuyen_Click(object sender, EventArgs e)
        {
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    String _Id = Item.Cells[1].Text;
                    VT_CHUYEN_NHAN o_Object = new VT_CHUYEN_NHAN();
                    VT_CHUYEN_NHAN_BL M_Object = new VT_CHUYEN_NHAN_BL();
                    string V_CANBO_NHAN_ID = "";
                    M_Object.VT_HUY_CHUYEN(_Id, ref V_CANBO_NHAN_ID);
                    if (V_CANBO_NHAN_ID == "")
                    {
                        lbtthongbao.Text = "Bạn đã hủy chuyển thành công";
                    }
                    else
                    {
                        lbtthongbao.Text = "Bạn không thể hủy chuyển đơn vị nhận đã nhận bản ghi này";
                    }
                }
            }
            Load_Data();
        }
        protected void chkFullAll_CheckChange(object sender, EventArgs e)
        {
            CheckBox chkAll = (CheckBox)sender;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Visible == true)
                {
                    chkChon.Checked = chkAll.Checked;
                }
            }
        }
        protected void Drop_TRANGTHAICHUYEN_SelectedIndexChanged(object sender, EventArgs e)
        {
            Check_btn_chuyenNhan();
           // Load_Data();
            Check_column_dgList();
        }
        protected void Check_btn_chuyenNhan()
        {
            String pb = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(btnThemmoi, oPer.TAOMOI);
            if(oPer.TAOMOI == true)
            {
                cmdNhanan.Visible = false;
                cmdHuyNhan.Visible = false;
                btnThemmoi.Visible = true;
                if (Drop_TRANGTHAICHUYEN.SelectedValue == "")
                {
                    cmdChuyen.Visible = false;
                    cmdHuychuyen.Visible = false;
                }
                else if (Drop_TRANGTHAICHUYEN.SelectedValue == "0")
                {
                    cmdChuyen.Visible = true;
                    cmdHuychuyen.Visible = false;
                }
                else if (Drop_TRANGTHAICHUYEN.SelectedValue == "1")
                {
                    cmdChuyen.Visible = false;
                    cmdHuychuyen.Visible = true;
                }
                else if (Drop_TRANGTHAICHUYEN.SelectedValue == "2")
                {
                    cmdChuyen.Visible = false;
                    cmdHuychuyen.Visible = true;

                }
                else if (Drop_TRANGTHAICHUYEN.SelectedValue == "3")
                {
                    cmdChuyen.Visible = false;
                    cmdHuychuyen.Visible = false;
                }
            }
            else
            {
                cmdChuyen.Visible = false;
                cmdHuychuyen.Visible = false;
                btnThemmoi.Visible = false;
                if (Drop_TRANGTHAICHUYEN.SelectedValue == "")
                {
                    cmdNhanan.Visible = false;
                    cmdHuyNhan.Visible = false;
                }
                else if (Drop_TRANGTHAICHUYEN.SelectedValue == "2")//chua nhận
                {
                    cmdNhanan.Visible = true;
                    cmdHuyNhan.Visible = false;
                }
                else if (Drop_TRANGTHAICHUYEN.SelectedValue == "3")//đã nhận
                {
                    cmdNhanan.Visible = false;
                   // cmdHuyNhan.Visible = true;
                  //  MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    cmdHuyNhan.Visible = oPer.XOA;// quyền xóa được gán tạm cho quyền hủy nhận
                }
            }
        }
        protected void Check_column_dgList()
        {
            String pb = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.TAOMOI == true)
            {
                    pb = "";
            }
            if (Drop_TRANGTHAICHUYEN.SelectedValue == "")
            {
                dgList.Columns[2].Visible = false;
               // dgList.Columns[14].Visible = false;
            }
            else if (Drop_TRANGTHAICHUYEN.SelectedValue == "0")
            {
                dgList.Columns[2].Visible = true;
               // dgList.Columns[14].Visible = true;
            }
            else if (Drop_TRANGTHAICHUYEN.SelectedValue == "1")
            {
                dgList.Columns[2].Visible = true;
               // dgList.Columns[14].Visible = false;
            }
            else if (Drop_TRANGTHAICHUYEN.SelectedValue == "2")
            {
                dgList.Columns[2].Visible = true;
              //  dgList.Columns[14].Visible = false;

            }
            else if (Drop_TRANGTHAICHUYEN.SelectedValue == "3")
            {
                if (pb == "")//văn bản đến
                {
                    dgList.Columns[2].Visible = false;
                  //  dgList.Columns[14].Visible = false;
                }
                else
                {
                    dgList.Columns[2].Visible = true;
                   // dgList.Columns[14].Visible = false;
                }
            }
        }
        protected void Load_TrangThaiChuyen()
        {
            String pb = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.TAOMOI == true)
            {
                    pb = "";
            }
            ListItem ites = new ListItem();
            Drop_TRANGTHAICHUYEN.Items.Clear();
            if (pb == "")//văn bản đến
            {
                ites = new ListItem("---Tất cả--- ", "");
                Drop_TRANGTHAICHUYEN.Items.Add(ites);
                ites = new ListItem("Đang lưu", "0");
                Drop_TRANGTHAICHUYEN.Items.Add(ites);
                ites = new ListItem("Đã chuyển", "1");
                Drop_TRANGTHAICHUYEN.Items.Add(ites);
                ites = new ListItem("--Chưa nhận", "2");
                Drop_TRANGTHAICHUYEN.Items.Add(ites);
                ites = new ListItem("--Đã nhận", "3");
                Drop_TRANGTHAICHUYEN.Items.Add(ites);
                //------
                Drop_TRANGTHAICHUYEN.SelectedValue = "0";
            }
            else if (pb == "1" || pb == "13" || pb == "9" || pb == "5")//văn phòng đại diện cho hành chính tư pháp
            {
                ites = new ListItem("---Tất cả--- ", "");
                Drop_TRANGTHAICHUYEN.Items.Add(ites);
                ites = new ListItem("Chưa nhận", "2");
                Drop_TRANGTHAICHUYEN.Items.Add(ites);
                ites = new ListItem("Đã nhận", "3");
                Drop_TRANGTHAICHUYEN.Items.Add(ites);
                //---
                Drop_TRANGTHAICHUYEN.SelectedValue = "2";
            }
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void cmdLammoi_search_Click(object sender, EventArgs e)
        {
            lbtthongbao.Text = String.Empty;
            DROP_LOAI_VB_SEARCH.SelectedValue = String.Empty;
            Drop_NGUOI_NHAN_SEARCH.SelectedValue = String.Empty;
            txt_SODEN_SEARCH.Text = String.Empty;
            txt_ID_SEARCH.Text= String.Empty;
            drop_LOAI_NGAY_SEARCH.SelectedValue = "0";
            txt_NGAY_FROM.Text = String.Empty;
            txt_NGAY_TO.Text = String.Empty;
            txt_NGUOI_GUI_BT_SEARCH.Text = String.Empty;
            txt_DIACHI_GUI_BT_SEARCH.Text = String.Empty;
            txt_GHICHU_SEARCH.Text = String.Empty;
            //---------------
            Drop_NGUONDEN_SEARCH.SelectedValue = String.Empty;
            txt_NGUOIDUNGDON_SEARCH.Text= String.Empty;
            Drop_LOAI_AN_DON_SEARCH.SelectedValue = String.Empty;
            Drop_TOAAN_BAQD_DON_SEARCH.SelectedValue = String.Empty;
            txt_SO_BAQD_DON_SEARCH.Text = String.Empty;
            txt_NGAY_BAQD_DON_SEARCH.Text = String.Empty;
            txt_NGUOITAO_SEARCH.Text = String.Empty;
            //--------------------
            Session[SS_TK.NGAYNHAPTU] = String.Empty;
            Session[SS_TK.NGAYNHAPDEN] = String.Empty;
            Session[SS_TK.TRANGTHAICHUYEN_VT] = String.Empty;
        }
        private void Load_Data()
        {
            lbTFirst.Visible = ddlPageCount.Visible = lbBFirst.Visible = ddlPageCount2.Visible = true;
            int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            DataTable oDT = getDS(page_size, pageindex);
            int count_all = 0;
            if (oDT.Rows.Count > 0)
            {
                count_all = Convert.ToInt32(oDT.Rows[0]["CountAll"] + "");
            }

            if (oDT != null && count_all > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,#", cul) + " </b> bản ghi " + "trong <b>" + hddTotalPage.Value + "</b> trang";
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

            dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
            dgList.DataSource = oDT;
            dgList.DataBind();
            Check_column_dgList();
        }
        private DataTable getDS(int page_size, int pageindex)
        {
            String _PHONGBANID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.TAOMOI == true)
            {
                _PHONGBANID = "";
            }
            VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
            DataTable tbl = obj_M.VT_VANBANDEN_SEARCH_APP(Session[ENUM_SESSION.SESSION_DONVIID] + "", Drop_NGUONDEN_SEARCH.SelectedValue, txt_NGUOIDUNGDON_SEARCH.Text.Trim(), Drop_LOAI_AN_DON_SEARCH.SelectedValue,Drop_TOAAN_BAQD_DON_SEARCH.SelectedValue,txt_SO_BAQD_DON_SEARCH.Text.Trim(),txt_NGAY_BAQD_DON_SEARCH.Text.Trim(),txt_NGUOITAO_SEARCH.Text.Trim()
                ,_PHONGBANID, DROP_LOAI_VB_SEARCH.SelectedValue,Drop_NOI_NHAN_SEARCH.SelectedValue
                ,Drop_NGUOI_NHAN_SEARCH.SelectedValue,txt_SODEN_SEARCH.Text.Trim(), txt_SODEN_SEARCH_DEN.Text.Trim(), txt_ID_SEARCH.Text.Trim(), drop_LOAI_NGAY_SEARCH.SelectedValue
                ,txt_NGAY_FROM.Text.Trim(),txt_NGAY_TO.Text.Trim(),txt_NGUOI_GUI_BT_SEARCH.Text.Trim(),txt_DIACHI_GUI_BT_SEARCH.Text.Trim(),txt_GHICHU_SEARCH.Text.Trim(),Drop_TRANGTHAICHUYEN.SelectedValue, pageindex,page_size);
            return tbl;
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            String pb = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (oPer.TAOMOI == true)
            {
                    pb = "";
            }
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                LinkButton lblChitiet = (LinkButton)e.Item.FindControl("lblChitiet");

                lblChitiet.Visible = oPer.XEM;
                lblSua.Visible = oPer.CAPNHAT;
                lbtXoa.Visible = oPer.XOA;
                
                CheckBox chkChon = (CheckBox)e.Item.FindControl("chkChon");

                String LOAI_VB = ((DataRowView)e.Item.DataItem)["LOAI_VB"].ToString();
                String CANBO_NHAN_ID = ((DataRowView)e.Item.DataItem)["CANBO_NHAN_ID"].ToString();
                String VANBANDEN_ID = ((DataRowView)e.Item.DataItem)["VANBANDEN_ID"].ToString();
                //String DONVI_GQ = ((DataRowView)e.Item.DataItem)["Drop_DVXULY_ID_DON"].ToString();
                //if (((DataRowView)e.Item.DataItem)["NGAY_BT"].ToString() == "01/01/0001")
                //{
                //    e.Item.Cells[5].Text = "----/----/----";
                //}
                //-----------
                if ((pb != "") && CANBO_NHAN_ID != "")//trường hợp user của phòng văn thư và đơn đã được văn phòng nhận
                {
                    chkChon.Visible = true;//mở nút hủy nhận của văn phòng để phục vụ tập huấn
                    lblSua.Visible = false;
                    lbtXoa.Visible = false;
                    //lblChitiet.Visible = true;
                }
                else
                {
                    if (VANBANDEN_ID == "")
                    {
                        lblSua.Visible = true;
                        lbtXoa.Visible = true;
                        //lblChitiet.Visible = true;
                    }
                    else if (VANBANDEN_ID != "")//---đã chuyển
                    {
                        lblSua.Visible = false;
                        lbtXoa.Visible = false;
                        //lblChitiet.Visible = true;
                    }
                    //------------------------
                    if (LOAI_VB == "5")
                    {
                        if (rv["DVXULY_ID_DON"].ToString() == "13" && rv["NOI_NHAN"].ToString() == "13")//nơi nhận là văn phòng trong Thông tin Giao nhận hồ sơ
                        {
                            chkChon.Visible = true;
                        }
                        else
                        {
                            chkChon.Visible = false;
                        }
                        //chkChon.Visible = false;
                    }
                    else
                    {
                        chkChon.Visible = true;
                    }
                }
                
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            switch (e.CommandName)
            {
                case "Sua":
                    string[] arr = e.CommandArgument.ToString().Split('#');
                    if (arr.Length > 0)
                    {
                        MP_Add.Show();
                        //ScriptManager.RegisterStartupScript(Ajax_Manager_Updata, this.GetType(), "chosen_Load_Popup_temp", "chosen_Load_Popup_temp()", true);
                        Hi_update.Value = arr[0] + "";
                        Infor_load(Hi_update.Value);
                        lbtthongbao_popup.Text = string.Empty;
                        cmdUpdate.Visible = true;
                    }
                    break;
                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    Xoa_vt(e.CommandArgument+"");
                    break;
                case "Chitiet":
                    string[] arrs = e.CommandArgument.ToString().Split('#');
                    if (arrs.Length > 0)
                    {
                        MP_Add.Show();
                        //ScriptManager.RegisterStartupScript(Ajax_Manager_Updata, this.GetType(), "chosen_Load_Popup_temp", "chosen_Load_Popup_temp()", true);
                        Hi_update.Value = arrs[0] + "";
                        Infor_load(Hi_update.Value);
                        lbtthongbao_popup.Text = string.Empty;
                        cmdUpdate.Visible = false;
                    }
                    break;
            }
        }
        void Xoa_vt(String _ID)
        {
            VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
            obj_M.VAN_BAN_DEN_DELETE(_ID);
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void Infor_load(String V_id)
        {
            VT_VANTHU_DEN_BL obj_M = new VT_VANTHU_DEN_BL();
            DataTable tbl = obj_M.VT_VANBANDEN_LOAD_BYID(Session[ENUM_SESSION.SESSION_DONVIID] + "",V_id);
            /////bì thư
            Drop_NGUONDEN.SelectedValue= tbl.Rows[0]["NGUON_DEN"] + "";
            CHECKBY_NGUONDEN();
            txt_MABUUDIEN.Text= tbl.Rows[0]["MABD"] + "";
            txt_SOLUONG_GAM.Text = tbl.Rows[0]["SOLUONG_GAM"] + "";
           // LoadAllLoaiAn();
            Drop_LOAI_VB.SelectedValue = tbl.Rows[0]["LOAI_VB"] + "";
            if (Drop_LOAI_VB.SelectedValue == "4")
            {
                lblInforBA.Text = "Thông tin Bản án/Quyết định bị Kháng nghị";
                lblLoaiDeNghi.Text = "Kháng nghị theo thủ tục";
            }
            else
            {
                lblInforBA.Text = "Thông tin Bản án/Quyết định";
                lblLoaiDeNghi.Text = "Đề nghị theo thủ tục";
            }
            Drop_LOAI_AN_DON.SelectedValue = tbl.Rows[0]["LOAI_AN_DON"] + "";
            QuanHePL_hs();
            LoaiVB_Load();
            NoiNhan_Load(CurrDonViID + "");
            Drop_NOI_NHAN.SelectedValue= tbl.Rows[0]["NOI_NHAN"] + "";
            DONVI_GQ_Load();
            LanhDao_Load(CurrDonViID + "");
            Drop_NGUOI_NHAN.SelectedValue = tbl.Rows[0]["NGUOI_NHAN"] + "";
            if (tbl.Rows[0]["LOAI_VB"] + "" == "5")
            {
                Drop_NGUOI_NHAN.SelectedValue = tbl.Rows[0]["NGUOI_NHAN"] + "";
                Drop_DVXULY_ID_DON.SelectedValue = tbl.Rows[0]["DVXULY_ID_DON"] + "";
            }
            if (((DateTime)tbl.Rows[0]["NGAY_DEN"]).ToString("dd/MM/yyyy") == "01/01/0001")
            {
                txt_NGAY_DEN.Text = "";
            }
            else
            {
                txt_NGAY_DEN.Text = ((DateTime)tbl.Rows[0]["NGAY_DEN"]).ToString("dd/MM/yyyy", cul);
            }
            txt_SODEN.Text = tbl.Rows[0]["SODEN"] + "";
            txt_NGUOI_GUI_BT.Text = tbl.Rows[0]["NGUOI_GUI_BT"] + "";

            if ( ((DateTime)tbl.Rows[0]["NGAY_BT"]).ToString("dd/MM/yyyy") ==  "01/01/0001")
            {
                txt_NGAY_BT.Text = "";
            }
            else
            {
                txt_NGAY_BT.Text = ((DateTime)tbl.Rows[0]["NGAY_BT"]).ToString("dd/MM/yyyy", cul);
            }
            LoadDiaChiGui();
            ddl_DIACHI_GUI_BT_ID.SelectedValue= tbl.Rows[0]["DIACHI_GUI_BT_ID"] + "";
            txt_DIACHI_GUI_BT.Text= tbl.Rows[0]["DIACHI_GUI_BT"] + "";
            txt_GHICHU.Text= tbl.Rows[0]["GHICHU"] + "";
            //---Nhập thông tin văn bản hành chính
            if (Drop_LOAI_VB.SelectedValue == "5")
            {
                txt_SO_VB.Text= tbl.Rows[0]["SO_VB"] + "";
                if (((DateTime)tbl.Rows[0]["NGAY_VB"]).ToString("dd/MM/yyyy") == "01/01/0001")
                {
                    txt_NGAY_VB.Text = "";
                }
                else
                {
                    txt_NGAY_VB.Text = ((DateTime)tbl.Rows[0]["NGAY_VB"]).ToString("dd/MM/yyyy", cul);
                }
                txt_NOIDUNG_VB.Text= tbl.Rows[0]["NOIDUNG_VB"] + "";
                //
                Drop_NOI_NHAN.Enabled = true;
                drop_DOKHAN.SelectedValue= tbl.Rows[0]["DO_KHAN_ID"] + "";
                drop_DOMAT.SelectedValue = tbl.Rows[0]["DOMAT_ID"] + "";
            }
            //---Nhập thông tin đon
            rdb_BAQD_CHECK.SelectedValue = tbl.Rows[0]["BAQD_CHECK_DON"] + "";
            if (Drop_LOAI_VB.SelectedValue == "1" || Drop_LOAI_VB.SelectedValue == "3")
            {
                txt_NGUOIDUNG_DON.Text= tbl.Rows[0]["NGUOIDUNGDON"] + "";
                LoadDiaChi_NguoiDungDon();
                ddl_DIACHI_NDD_ID.SelectedValue = tbl.Rows[0]["DIACHI_NDD_ID"] + "";
                txt_DIACHI_NG_DUNGDON.Text = tbl.Rows[0]["DIACHI_NDD"] + "";
                txt_SOLUONG_DON.Text= tbl.Rows[0]["SOLUONG_DON"] + "";                
                //rdb_BAQD_CHECK.SelectedValue= tbl.Rows[0]["BAQD_CHECK_DON"] + "";
                //
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "4")//Tòa án nhân dân cấp cao tại Hà Nội
                    Drop_NOI_NHAN.SelectedValue = "5";//mặc định sẽ là văn phòng nhận
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "5")//Tòa án nhân dân cấp cao tại Đà Nẵng
                    Drop_NOI_NHAN.SelectedValue = "9";//mặc định sẽ là văn phòng nhận
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "6")//Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh
                    Drop_NOI_NHAN.SelectedValue = "13";//mặc định sẽ là văn phòng nhận
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "1")//Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh
                    Drop_NOI_NHAN.SelectedValue = "1";//mặc định sẽ là văn phòng nhận
                Drop_NOI_NHAN.Enabled = false;
            }
            //---Công văn chuyển đơn (CV)
            if (Drop_LOAI_VB.SelectedValue == "2")
            {
                txt_SO_CV.Text = tbl.Rows[0]["SO_CV"] + "";
                if (((DateTime)tbl.Rows[0]["NGAY_CV"]).ToString("dd/MM/yyyy") == "01/01/0001")
                {
                    txt_NGAY_CV.Text = "";
                }
                else
                {
                    txt_NGAY_CV.Text = ((DateTime)tbl.Rows[0]["NGAY_CV"]).ToString("dd/MM/yyyy", cul);
                }
                txt_DONVICHUYEN_CV.Text = tbl.Rows[0]["DONVICHUYEN_CV"] + "";
                txt_NOIDUNG_CV.Text = tbl.Rows[0]["NOIDUNG_CV"] + "";
                
            }
            //---Công văn chuyển đơn (đơn + CV) và Công văn kiến nghị
             if (Drop_LOAI_VB.SelectedValue == "3" || Drop_LOAI_VB.SelectedValue == "6" || Drop_LOAI_VB.SelectedValue == "9")
            {
                txt_SO_CV.Text = tbl.Rows[0]["SO_CV"] + "";
                if (tbl.Rows[0]["NGAY_CV"] + "" == "")
                {
                    txt_NGAY_CV.Text = "";
                }
                else
                {
                    if (((DateTime)tbl.Rows[0]["NGAY_CV"]).ToString("dd/MM/yyyy") == "01/01/0001")
                    {
                        txt_NGAY_CV.Text = "";
                    }
                    else
                    {
                        txt_NGAY_CV.Text = ((DateTime)tbl.Rows[0]["NGAY_CV"]).ToString("dd/MM/yyyy", cul);
                    }
                }
                txt_DONVICHUYEN_CV.Text = tbl.Rows[0]["DONVICHUYEN_CV"] + "";
                txt_NOIDUNG_CV.Text = tbl.Rows[0]["NOIDUNG_CV"] + "";
                //
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "4")//Tòa án nhân dân cấp cao tại Hà Nội
                    Drop_NOI_NHAN.SelectedValue = "5";//mặc định sẽ là văn phòng nhận
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "5")//Tòa án nhân dân cấp cao tại Đà Nẵng
                    Drop_NOI_NHAN.SelectedValue = "9";//mặc định sẽ là văn phòng nhận
                if (Session[ENUM_SESSION.SESSION_DONVIID] + "" == "6")//Tòa án nhân dân cấp cao tại thành phố Hồ Chí Minh
                    Drop_NOI_NHAN.SelectedValue = "13";//mặc định sẽ là văn phòng nhận
                Drop_NOI_NHAN.Enabled = false;
                //
            }
            //---Hồ sơ
             if (Drop_LOAI_VB.SelectedValue == "4")
            {
                LoadDropNGuoiKy_VKS();
                txtSOKN.Text = tbl.Rows[0]["SO_HS"] + "";
                if (((DateTime)tbl.Rows[0]["NGAY_HS"]).ToString("dd/MM/yyyy") == "01/01/0001")
                {
                    txt_NGAYQDKN.Text = "";
                }
                else
                {
                    txt_NGAYQDKN.Text = ((DateTime)tbl.Rows[0]["NGAY_HS"]).ToString("dd/MM/yyyy", cul);
                }
                dropVKS_NguoiKy.SelectedValue = tbl.Rows[0]["DONVICHUYEN_HS"] + "";
                txt_GHICHU_HS.Text = tbl.Rows[0]["GHICHU_HS"] + "";
                //------
                Drop_NOI_NHAN.Enabled = true;
            }
            string vLoaiVB = Drop_LOAI_VB.SelectedValue;
            if (vLoaiVB == "1" || vLoaiVB == "3" || vLoaiVB == "4" || vLoaiVB == "6"|| vLoaiVB == "9" || vLoaiVB == "7"|| vLoaiVB == "8")
            {
                string vLoaiGDT = tbl.Rows[0]["LOAI_GDTTTT"] + "";
                if (vLoaiGDT != "")
                    drop_LoaiGDT.SelectedValue = vLoaiGDT;
                else
                    drop_LoaiGDT.SelectedValue = "0";
                //Drop_LOAI_AN_DON.SelectedValue = tbl.Rows[0]["LOAI_AN_DON"] + "";
                if (rdb_BAQD_CHECK.SelectedValue == "1")
                {
                    string vLoaidon = tbl.Rows[0]["LOAI_AN_DON"]+"";
                    if (vLoaidon != "0" && vLoaidon != "")
                    {
                        Drop_LOAI_AN_DON.SelectedValue = tbl.Rows[0]["LOAI_AN_DON"] + "";
                        if (vLoaidon == "1")
                        {
                            div_HINHSU.Style.Add("Display", "block");
                            div_QHPL.Style.Add("Display", "block");
                            div_DANSU_EXT.Style.Add("Display", "none");
                            div_QHPL_DS.Style.Add("Display", "none");
                        }
                        else
                        {
                            div_DANSU_EXT.Style.Add("Display", "block");
                            div_QHPL_DS.Style.Add("Display", "block");
                            div_HINHSU.Style.Add("Display", "none");
                            div_QHPL.Style.Add("Display", "none");
                        }
                            
                    }
                    string vCapXX = tbl.Rows[0]["CAP_XX_DON"] + "";
                    if(vCapXX !="" && vCapXX != "0")
                        Drop_CAP_XX_DON.SelectedValue = tbl.Rows[0]["CAP_XX_DON"] + "";
                    txt_SO_BAQD_DON.Text = tbl.Rows[0]["SO_BAQD_DON"] + "";
                    if (((DateTime)tbl.Rows[0]["NGAY_BAQD_DON"]).ToString("dd/MM/yyyy") == "01/01/0001")
                    {
                        txt_NGAY_BAQD_DON.Text = "";
                    }
                    else
                    {
                        txt_NGAY_BAQD_DON.Text = ((DateTime)tbl.Rows[0]["NGAY_BAQD_DON"]).ToString("dd/MM/yyyy", cul);
                    }
                    string vToaxx = tbl.Rows[0]["TOAAN_BAQD_DON"] + "";
                    if (vToaxx != "" && vToaxx != "0")
                        Drop_TOAAN_BAQD_DON.SelectedValue = tbl.Rows[0]["TOAAN_BAQD_DON"] + "";
                }
                else if (rdb_BAQD_CHECK.SelectedValue == "0")
                {
                    div_BA_QD.Style.Add("Display", "none");
                    Drop_LOAI_AN_DON.SelectedValue = "0";
                    Drop_CAP_XX_DON.SelectedValue = "0";
                    txt_SO_BAQD_DON.Text = string.Empty;
                    txt_NGAY_BAQD_DON.Text = string.Empty;
                    Drop_TOAAN_BAQD_DON.SelectedValue = "0";
                }
                if (Drop_LOAI_AN_DON.SelectedValue == "1")
                {
                    txt_BICAO_HS.Text = tbl.Rows[0]["BIDON_DON"] + "";
                    if(tbl.Rows[0]["QHPL_HS_DON"] + ""=="")
                    {
                        Drop_QHPL.SelectedValue = "0";
                    }
                    else
                    Drop_QHPL.SelectedValue = tbl.Rows[0]["QHPL_HS_DON"] + "";
                }
                else
                {
                    txt_BIDON.Text = tbl.Rows[0]["BIDON_DON"] + "";
                    txt_NGUYENDON.Text = tbl.Rows[0]["NGUYENDON_DON"] + "";
                    txtQHPL.Text = tbl.Rows[0]["QHPL_DS_DON"] + "";

                }
            }
            string vDonViNhan = tbl.Rows[0]["DVXULY_ID_DON"] + "";
            //if (vDonViNhan != "" && vDonViNhan != "0")
            //{
                CAN_BO_Load(CurrDonViID + "", tbl.Rows[0]["DVXULY_ID_DON"] + "");
                Drop_DVXULY_ID_DON.SelectedValue = tbl.Rows[0]["DVXULY_ID_DON"] + "";
            //}
            //else
            //    Drop_DVXULY_ID_DON.SelectedValue = PhongBanID + "";
            string vCanboNhan = tbl.Rows[0]["CANBONHAN_ID"] + "";
            if (vCanboNhan != "" && vCanboNhan != "0")
                Drop_CANBONHAN_ID.SelectedValue = tbl.Rows[0]["CANBONHAN_ID"] + "";
            else
                Drop_CANBONHAN_ID.SelectedValue = "0";
            string vNgaygiao = tbl.Rows[0]["NGAY_GIAO_DON"] +"";
            if (vNgaygiao != "")
            {
                if (((DateTime)tbl.Rows[0]["NGAY_GIAO_DON"]).ToString("dd/MM/yyyy") == "01/01/0001")
                {
                    txtNgaygiao.Text = "";
                }
                else
                {
                    txtNgaygiao.Text = ((DateTime)tbl.Rows[0]["NGAY_GIAO_DON"]).ToString("dd/MM/yyyy", cul);
                }
            }else
                txtNgaygiao.Text = "";

            BA_QD_Load();
        }
        void LoadDropNGuoiKy_VKS()
        {
            dropVKS_NguoiKy.Items.Clear();
            DM_VKS_BL objBL = new DM_VKS_BL();
            DataTable tbl = objBL.GetAll_VKS_CapCao();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropVKS_NguoiKy.DataSource = tbl;
                dropVKS_NguoiKy.DataTextField = "Ten";
                dropVKS_NguoiKy.DataValueField = "ID";
                dropVKS_NguoiKy.DataBind();

                // 10.5.24 Đóng lại để load tất cả các Người kháng nghị
                // Do Form chỉ load CA và Viện trưởng VKS tối cao khi nơi nhận là Tối cao
                // Tuy nhưng nơi gửi lại là cấp cao nên báo lỗi vì dropVKS_NguoiKy không load đủ
                //ListItemCollection liCol = dropVKS_NguoiKy.Items;
                //for (int i = 0; i < tbl.Rows.Count; i++)
                //{
                //    string v_loaivks = tbl.Rows[i]["LOAIVKS"] + "";
                //    string v_TOAANID = tbl.Rows[i]["TOAANID"] + "";

                //    if (v_loaivks == "CAPCAO" && v_TOAANID != CurrDonViID.ToString())
                //    {
                //        string v_index = tbl.Rows[i]["ID"]+"";
                //        for (int j = 0; j < liCol.Count; j++)
                //        {
                //            ListItem li = liCol[j];
                //            if (li.Value == v_index)
                //                dropVKS_NguoiKy.Items.Remove(li);
                //        }
                //    }
                //}
            }

            dropVKS_NguoiKy.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

        }
        //--------------------------------------------------
        protected void Drop_DVXULY_ID_DON_SelectedIndexChanged(object sender, EventArgs e)
        {
            //string vPhongBan = Drop_DVXULY_ID_DON.SelectedValue;
            //CAN_BO_Load(CurrDonViID + "", vPhongBan);
        }
        #endregion
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            // dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }
        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            //  dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            // dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion
    }
}