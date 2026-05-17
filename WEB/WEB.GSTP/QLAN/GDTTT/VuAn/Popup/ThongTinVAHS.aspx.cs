using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class ThongTinVAHS : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrentUserID = 0;
        public Decimal VuAnID = 0;
        List<GDTTT_DON> lstDon = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            scriptManager.RegisterPostBackControl(this.cmdPrintContent);

            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    if (VuAnID > 0)
                    {
                        lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == VuAnID
                                                      && x.CD_TRANGTHAI == 2
                                                      && x.ISTHULY == 1).OrderBy(x => x.TL_NGAY).ToList();

                        //-----------------------------
                        GDTTT_VUAN obj = dt.GDTTT_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
                        LoadThongTinVuAn(obj);

                        //------------------------------
                        try
                        {
                            //txtVuAn_SoThuLy.Text = (String.IsNullOrEmpty(obj.SOTHULYDON + "") ? "" : ("Số <b>" + obj.SOTHULYDON + "</b>"))
                            //                        + ((String.IsNullOrEmpty(obj.NGAYTHULYDON + "") || (obj.NGAYTHULYDON == DateTime.MinValue)) ? "" : (" ngày <b>" + ((DateTime)obj.NGAYTHULYDON).ToString("dd/MM/yyyy", cul) + "</b>"));
                            Load_ThongTinThuLy(VuAnID, lstDon);
                        }
                        catch (Exception ex) { }

                        //---------------------------

                        try { LoadBiCao(VuAnID); } catch (Exception ex) { }

                        //---------------------
                        try { Load_HoanTHA(obj); } catch (Exception ex) { }

                        //-----------------------
                        #region Lay an quoc hoi
                        try
                        {
                            decimal temp_id = (string.IsNullOrEmpty(obj.ISANQUOCHOI + "")) ? 0 : (decimal)obj.ISANQUOCHOI;
                            if (temp_id > 0)
                            {
                                Load_AnQuocHoi(VuAnID);
                                //------------------------------
                                LoadDsThongBaoTT_TLDon();
                            }
                            else pnAnQH.Visible = pnThongBaoTL.Visible = pnThongBaoTT.Visible = false;
                        }
                        catch (Exception ex) { pnAnQH.Visible = pnThongBaoTL.Visible = pnThongBaoTT.Visible = false; }
                        #endregion
                        //-------------------------
                        try { Load_AnChiDao(VuAnID); } catch (Exception ex) { }
                        //-----------------------------
                        try { Load_TTV_LanhDao(obj); } catch (Exception ex) { }

                        //--------------------
                        try { Load_QLHoSo(); } catch (Exception ex) { }

                        //----------------------
                        try { LoadToTrinh(); } catch (Exception ex) { }

                        //----------------------
                        try
                        {
                            //LoadDsNguoiKhieuNai_KQGQ(obj, lstDon);
                            LoadDSnguoiKN_Noidung(VuAnID);
                            //LoadDsNguoiKhieuNai(lstDon);
                        }
                        catch (Exception ex) { }
                        try
                        {
                            LoadKQGQDon_AHS(obj);
                        }
                        catch (Exception ex) { }


                        //---------------------------
                        try { Load_XetXuGDTTT(obj); } catch (Exception ex) { }
                    }
                }
            }
        }
       
        void Load_ThongTinThuLy(Decimal VuAnID, List<GDTTT_DON> lstDon)
        {
            String Str = "";
            if (lstDon == null)
            {
                lstDon = dt.GDTTT_DON.Where(x => x.VUVIECID == VuAnID
                                                       && x.CD_TRANGTHAI == 2
                                                       && x.ISTHULY == 1).OrderBy(x => x.TL_NGAY).ToList();
            }
            if (lstDon != null && lstDon.Count > 0)
            {
                int count_item = 1;
                foreach (GDTTT_DON item in lstDon)
                {
                    if (string.IsNullOrEmpty(lttIsTuHinh.Text))
                        lttIsTuHinh.Text = (string.IsNullOrEmpty(item.ISANTUHINH + "") || (item.ISANTUHINH == 0)) ? "" : "Có";

                    Str += "<div class='row_info'>";
                    Str += "Thụ lý lần <b>" + count_item.ToString() + "</b>";
                    Str += "<span style='margin-left: 5px;'>";
                    Str += (String.IsNullOrEmpty(item.TL_SO + "") ? "" : "số " + item.TL_SO);
                    Str += (String.IsNullOrEmpty(item.TL_NGAY + "") ? "" : (" ngày " + ((DateTime)item.TL_NGAY).ToString("dd/MM/yyyy", cul) + ""));
                    Str += "</span>";
                    Str += String.IsNullOrEmpty(item.NGUOIGUI_HOTEN + "") ? "" : " của " + item.NGUOIGUI_HOTEN;
                    Str += "</div>";
                    count_item++;
                }
                txtVuAn_SoThuLy.Text = Str;
            }
            if (string.IsNullOrEmpty(lttIsTuHinh.Text))
                lttIsTuHinh.Text = "Không";
        }
        void LoadThongTinVuAn(GDTTT_VUAN obj)
        {
            string temp = "";
            string temp_str = "";
            decimal temp_id = 0;
            if (obj != null)
            {
                temp_str = "";
                temp_id = String.IsNullOrEmpty(obj.LOAIAN + "") ? 0 : (decimal)obj.LOAIAN;
                lttLoaiAn.Text = "Hình sự";
                lttTenVuAn.Text = obj.TENVUAN;// + (String.IsNullOrEmpty(obj.NGUYENDON+"")? "": (string.IsNullOrEmpty(obj.)));

                //------------------------
                #region BA/QD  phuc tham, ST
                if (obj.BAQD_CAPXETXU == 4)
                {
                    temp = temp_str = "";
                    try
                    {
                        temp = (String.IsNullOrEmpty(obj.SO_QDGDT + "")) ? "" : ("Số <b>" + obj.SO_QDGDT + "</b>");
                        temp += (String.IsNullOrEmpty(obj.NGAYQD + "") || (obj.NGAYQD == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYQD).ToString("dd/MM/yyyy", cul) + "</b>";
                        lttBanAnDenghi.Text = temp;
                    }
                    catch (Exception ex) { }

                    DM_TOAAN objTA = null;
                    temp_id = String.IsNullOrEmpty(obj.TOAQDID + "") ? 0 : (decimal)obj.TOAQDID;
                    if (temp_id > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAQDID).Single();
                        lttToaXuDenghi.Text = objTA.MA_TEN;
                    }
                    //--BA PT neu co
                    string toa_PT = "", soPT = "", ngaypt = "";
                    decimal toaptID = 0;
                    ngaypt = (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul) + "</b>";
                    soPT = (String.IsNullOrEmpty(obj.SOANPHUCTHAM + "")) ? "" : ("Số <b>" + obj.SOANPHUCTHAM + "</b>");
                    toaptID = String.IsNullOrEmpty(obj.TOAPHUCTHAMID + "") ? 0 : (decimal)obj.TOAPHUCTHAMID;
                    if (toaptID > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAPHUCTHAMID).Single();
                        toa_PT = " tại " + objTA.MA_TEN;
                    }
                    lttBanAnPT.Text = soPT + ngaypt + toa_PT;
                    if (String.IsNullOrEmpty(lttBanAnPT.Text.Trim()))
                        pnAnPT.Visible = false;
                    else pnAnPT.Visible = true;

                    //-----ST neu co-------------
                    string toa_ST = "", soST = "", ngayST = "";
                    decimal toaST_id = 0;
                    ngayST = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul) + "</b>";
                    soST = (String.IsNullOrEmpty(obj.SOANSOTHAM + "")) ? "" : ("Số <b>" + obj.SOANSOTHAM + "</b>");
                    toaST_id = String.IsNullOrEmpty(obj.TOAANSOTHAM + "") ? 0 : (decimal)obj.TOAANSOTHAM;
                    if (toaST_id > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANSOTHAM).Single();
                        toa_ST = " tại " + objTA.MA_TEN;
                    }
                    lttBanAnST.Text = soST + ngayST + toa_ST;
                    if (String.IsNullOrEmpty(lttBanAnST.Text.Trim()))
                        pnAnST.Visible = false;
                    else pnAnST.Visible = true;
                }
                else if (obj.BAQD_CAPXETXU == 2)
                {
                    temp = temp_str = "";
                    try
                    {
                        temp = (String.IsNullOrEmpty(obj.SOANSOTHAM + "")) ? "" : ("Số <b>" + obj.SOANSOTHAM + "</b>");
                        temp += (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul) + "</b>";
                        lttBanAnDenghi.Text = temp;
                    }
                    catch (Exception ex) { }

                    DM_TOAAN objTA = null;
                    temp_id = String.IsNullOrEmpty(obj.TOAANSOTHAM + "") ? 0 : (decimal)obj.TOAANSOTHAM;
                    if (temp_id > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANSOTHAM).Single();
                        lttToaXuDenghi.Text = objTA.MA_TEN;
                    }
                    pnAnPT.Visible = pnAnST.Visible = false;
                }
                else
                {
                    try
                    {
                        temp = (String.IsNullOrEmpty(obj.SOANPHUCTHAM + "")) ? "" : ("Số <b>" + obj.SOANPHUCTHAM + "</b>");
                        temp += (String.IsNullOrEmpty(obj.NGAYXUPHUCTHAM + "") || (obj.NGAYXUPHUCTHAM == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYXUPHUCTHAM).ToString("dd/MM/yyyy", cul) + "</b>";
                        lttBanAnDenghi.Text = temp;
                    }
                    catch (Exception ex) { }

                    DM_TOAAN objTA = null;
                    temp_id = String.IsNullOrEmpty(obj.TOAPHUCTHAMID + "") ? 0 : (decimal)obj.TOAPHUCTHAMID;
                    if (temp_id > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAPHUCTHAMID).Single();
                        lttToaXuDenghi.Text = objTA.MA_TEN;
                    }
                    //------------------
                    string toa_ST = "", soST = "", ngayST = "";
                    decimal toaST_id = 0;
                    ngayST = (String.IsNullOrEmpty(obj.NGAYXUSOTHAM + "") || (obj.NGAYXUSOTHAM == DateTime.MinValue)) ? "" : "  ngày <b>" + ((DateTime)obj.NGAYXUSOTHAM).ToString("dd/MM/yyyy", cul) + "</b>";
                    soST = (String.IsNullOrEmpty(obj.SOANSOTHAM + "")) ? "" : ("Số <b>" + obj.SOANSOTHAM + "</b>");
                    toaST_id = String.IsNullOrEmpty(obj.TOAANSOTHAM + "") ? 0 : (decimal)obj.TOAANSOTHAM;
                    if (toaST_id > 0)
                    {
                        objTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANSOTHAM).Single();
                        toa_ST = " tại " + objTA.MA_TEN;
                    }
                    lttBanAnST.Text = soST + ngayST + toa_ST;
                    if (String.IsNullOrEmpty(lttBanAnST.Text.Trim()))
                        pnAnST.Visible = false;
                    else pnAnST.Visible = true;

                    pnAnPT.Visible = false;

                }


                #endregion
                //------------------------
                lttGhiChu.Text = obj.GHICHU + "";
            }
        }
        void LoadDSnguoiKN_Noidung(decimal vVuAnID)
        {
            List<GDTTT_VUAN_DS_KN> NguoiKN = dt.GDTTT_VUAN_DS_KN.Where(x => x.VUANID == vVuAnID).OrderBy(x => x.VUANID).ToList();
            String TenNguoiKN = "", AllNoiDung = "";
            GDTTT_VUAN_DUONGSU Duongsu = null;
            GDTTT_VUAN_DUONGSU BiCao = null;
            if (NguoiKN != null && NguoiKN.Count > 0)
            {
                foreach( GDTTT_VUAN_DS_KN oDuongsuKN in NguoiKN)
                {
                    Duongsu = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == oDuongsuKN.NGUOIKHIEUNAIID && x.HS_ISKHIEUNAI == 1).Single();
                    BiCao = dt.GDTTT_VUAN_DUONGSU.Where(x => x.ID == oDuongsuKN.NGUOIKHIEUNAIID).Single();
                    AllNoiDung = Duongsu.TENDUONGSU + " " + oDuongsuKN.NOIDUNGKHIEUNAI;
                    if ((!String.IsNullOrEmpty(TenNguoiKN + "")) && (!String.IsNullOrEmpty(AllNoiDung + "")))
                        TenNguoiKN += "; <br/> ";
                    TenNguoiKN += AllNoiDung;
                }
                lttVuAn_NguoiKhieuNai.Text = TenNguoiKN;
            }
        }
        void LoadDsNguoiKhieuNai(List<GDTTT_DON> lstKN)
        {
            if (lstKN == null)
            {
                lstKN = dt.GDTTT_DON.Where(x => x.VUVIECID == VuAnID
                                             && x.CD_TRANGTHAI == 2
                                             && x.ISTHULY == 1).OrderBy(x => x.TL_NGAY).ToList();
            }
            String TenNguoiKN = "", temp = "";
            if (lstKN != null && lstKN.Count > 0)
            {
                foreach (GDTTT_DON oDon in lstKN)
                {
                    temp = oDon.NGUOIGUI_HOTEN;
                    if ((!String.IsNullOrEmpty(TenNguoiKN + "")) && (!String.IsNullOrEmpty(temp + "")))
                        TenNguoiKN += ", ";
                    TenNguoiKN += temp;
                }
                lttVuAn_NguoiKhieuNai.Text = TenNguoiKN;
            }

            //else
            //{
            //    pnGQD.Visible = true;
            //    Load_GQDon(oVA);
            //}
        }
        void LoadKQGQDon_AHS(GDTTT_VUAN oVA)
        {
            String temp = "";
            string seperate_string = "  ";
            int kq = String.IsNullOrEmpty(oVA.GQD_LOAIKETQUA + "") ? 4 : (int)oVA.GQD_LOAIKETQUA;
            if (kq < 4)
            {
                pnGQD.Visible = true;
                if (kq == 0)
                {
                    GDTTT_DON oDon = null;
                    String StrDisplay = "", nguoiky = "", tt_nguoikhieunai = "";
                    //Tra loi don 
                    List<GDTTT_DON_TRALOI> lstDonTL = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID && x.TYPETB == 3 ).ToList();
                    if (lstDonTL != null && lstDonTL.Count > 0)
                    {
                        foreach (GDTTT_DON_TRALOI oTL in lstDonTL)
                        {
                            temp = (string.IsNullOrEmpty(oTL.SO) ? "" : "Số " + oTL.SO);
                            temp += (string.IsNullOrEmpty(temp) ? ""
                                    : (String.IsNullOrEmpty(oTL.NGAY + "") ? "" : " - ngày ")) + (String.IsNullOrEmpty(oTL.NGAY + "") ? "" : ((DateTime)oTL.NGAY).ToString("dd/MM/yyyy", cul));

                            nguoiky = (string.IsNullOrEmpty(oTL.NGUOIKY) ? "" : "<span style='margin-left: 5px;'>người ký: " + oTL.NGUOIKY + "</span>");
                            tt_nguoikhieunai = string.IsNullOrEmpty(oTL.NGUOINHAN) ? "" : "<span style='margin-left: 5px;'> cho: </span>" + oTL.NGUOINHAN;

                            if (!String.IsNullOrEmpty(oTL.DONID + ""))
                            {
                                tt_nguoikhieunai += string.IsNullOrEmpty(tt_nguoikhieunai + "") ? "" : " ";
                                oDon = dt.GDTTT_DON.Where(x => x.ID == oTL.DONID).Single();
                                if (oDon != null)
                                {
                                    tt_nguoikhieunai += "<span style='margin-left: 5px;'>(";
                                    tt_nguoikhieunai += String.IsNullOrEmpty(oDon.TL_SO + "") ? "" : "Số " + oDon.TL_SO;
                                    tt_nguoikhieunai += (string.IsNullOrEmpty(tt_nguoikhieunai) ? ""
                                              : (String.IsNullOrEmpty(oDon.TL_NGAY + "") ? "" : " ngày " + ((DateTime)oDon.TL_NGAY).ToString("dd/MM/yyyy", cul)));
                                    tt_nguoikhieunai += "</span>)";
                                }
                            }

                            //------------------------------
                            StrDisplay += "<div class='row_info'>";
                            StrDisplay += "<div style= 'float: left;width:100%; vertical-align: top;' >" + "<b>TLĐ:</b> " + temp;
                            StrDisplay += "" + nguoiky;
                            StrDisplay += "" + tt_nguoikhieunai;
                            StrDisplay += "</div>";
                            lttGQDThongTin.Text = StrDisplay;
                        }
                    }
                    else
                    {
                        lttGQDThongTin.Text = "Trả lời đơn";
                        lttGQDThongTin.Text += ":";
                        //---------------------------
                        temp = "";
                        temp = (string.IsNullOrEmpty(oVA.GQD_NGAYPHATHANHCV + "") || oVA.GQD_NGAYPHATHANHCV == DateTime.MinValue) ? "" : ((DateTime)oVA.GQD_NGAYPHATHANHCV).ToString("dd/MM/yyyy", cul);
                        if (temp != "")
                            lttGQDThongTin.Text += (String.IsNullOrEmpty(temp + "") ? "" : (seperate_string + "Ngày phát hành: <b>" + temp + "</b>"));
                        //---------------------------
                        string ghichu = (string.IsNullOrEmpty(oVA.GQD_GHICHU + "")) ? "" : oVA.GQD_GHICHU.Trim();
                        if ((ghichu != "") || (temp != ""))
                            lttGQDThongTin.Text += (string.IsNullOrEmpty(oVA.GQD_GHICHU + "")) ? "" : "<br/>Ghi chú: " + ghichu + "";
                    }
                }else if (kq == 1 && oVA.ISVIENTRUONGKN != 1)
                {
                    //Tra loi don Và kháng nghị của CA
                    GDTTT_DON oDon = null;
                    String StrDisplay = "", nguoiky = "", tt_nguoikhieunai = "";
                    //Ket qua Khang Nghị Neu co
                    List<GDTTT_DON_TRALOI> lstDonKN = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID && x.TYPETB == 4).ToList();
                    if (lstDonKN != null && lstDonKN.Count > 0)
                    {
                        foreach (GDTTT_DON_TRALOI oKN in lstDonKN)
                        {
                            temp = (string.IsNullOrEmpty(oKN.SO) ? "" : "Số " + oKN.SO);
                            temp += (string.IsNullOrEmpty(temp) ? ""
                                    : (String.IsNullOrEmpty(oKN.NGAY + "") ? "" : " - ngày ")) + (String.IsNullOrEmpty(oKN.NGAY + "") ? "" : ((DateTime)oKN.NGAY).ToString("dd/MM/yyyy", cul));

                            nguoiky = (string.IsNullOrEmpty(oKN.NGUOIKY) ? "" : "<span style='margin-left: 5px;'>người ký: CA " + oKN.NGUOIKY + "</span>");
                            tt_nguoikhieunai = string.IsNullOrEmpty(oKN.NGUOINHAN) ? "" : "<span style='margin-left: 5px;'> cho: </span>" + oKN.NGUOINHAN;

                            if (!String.IsNullOrEmpty(oKN.DONID + ""))
                            {
                                tt_nguoikhieunai += string.IsNullOrEmpty(tt_nguoikhieunai + "") ? "" : " ";
                                if (oKN.DONID > 0)
                                {
                                    oDon = dt.GDTTT_DON.Where(x => x.ID == oKN.DONID).Single();
                                    if (oDon != null)
                                    {
                                        tt_nguoikhieunai += "<span style='margin-left: 5px;'>(";
                                        tt_nguoikhieunai += String.IsNullOrEmpty(oDon.TL_SO + "") ? "" : "Số " + oDon.TL_SO;
                                        tt_nguoikhieunai += (string.IsNullOrEmpty(tt_nguoikhieunai) ? ""
                                                  : (String.IsNullOrEmpty(oDon.TL_NGAY + "") ? "" : " ngày " + ((DateTime)oDon.TL_NGAY).ToString("dd/MM/yyyy", cul)));
                                        tt_nguoikhieunai += ")</span>";
                                    }
                                }
                            }

                            //------------------------------
                            StrDisplay += "<div class='row_info'>";
                            StrDisplay += "<div style= 'float: left;width:100%; vertical-align: top;' >" + "<b>Kháng Nghị:</b> " + temp;
                            StrDisplay += "" + nguoiky;
                            StrDisplay += "" + tt_nguoikhieunai;
                            StrDisplay += "</div>";
                            
                        }
                    }
                    else
                    {
                        temp = (String.IsNullOrEmpty(oVA.GDQ_SO + "")) ? "" : "số <b>" + oVA.GDQ_SO + "</b>"
                                    + ((string.IsNullOrEmpty(oVA.GDQ_NGAY + "") || oVA.GDQ_NGAY == DateTime.MinValue) ? "" : "  ngày <b>" + ((DateTime)oVA.GDQ_NGAY).ToString("dd/MM/yyyy", cul) + "</b>");
                        if (temp != "")
                            StrDisplay += "<span style='margin-left:5px;'>" + temp + "</span>";

                        //----------nguoi ky- tham quyen xx---------------
                        temp = "";
                       
                        if (!string.IsNullOrEmpty(nguoiky))
                            lttGQDThongTin.Text += "<span style='margin-left:10px;'>Người ký: " + nguoiky + temp + "</span>";
                        int is_kn_vks = String.IsNullOrEmpty(oVA.ISVIENTRUONGKN + "") ? 0 : Convert.ToInt16(oVA.ISVIENTRUONGKN);
                        lttLoaiKQ.Text = "<b>Kháng nghị " + ((is_kn_vks == 0) ? "(CA)" : "(VKS)") + "</b>";

                        lttLoaiKQ.Text += ":";
                        //---------------------------
                        temp = "";
                        temp = (string.IsNullOrEmpty(oVA.GQD_NGAYPHATHANHCV + "") || oVA.GQD_NGAYPHATHANHCV == DateTime.MinValue) ? "" : ((DateTime)oVA.GQD_NGAYPHATHANHCV).ToString("dd/MM/yyyy", cul);
                        if (temp != "")
                            StrDisplay += (String.IsNullOrEmpty(temp + "") ? "" : (seperate_string + "Ngày phát hành: <b>" + temp + "</b>"));
                        //---------------------------
                        string ghichu = (string.IsNullOrEmpty(oVA.GQD_GHICHU + "")) ? "" : oVA.GQD_GHICHU.Trim();
                        if ((ghichu != "") || (temp != ""))
                            StrDisplay += (string.IsNullOrEmpty(oVA.GQD_GHICHU + "")) ? "" : "<br/>Ghi chú: " + ghichu + "";
                    }
                    
                    //Ket qua Tra loi don Neu co
                    List<GDTTT_DON_TRALOI> lstDonTL = dt.GDTTT_DON_TRALOI.Where(x => x.VUANID == VuAnID && x.TYPETB == 3 ).ToList();
                    if (lstDonTL != null && lstDonTL.Count > 0)
                    {
                        foreach (GDTTT_DON_TRALOI oTL in lstDonTL)
                        {
                            temp = (string.IsNullOrEmpty(oTL.SO) ? "" : "Số " + oTL.SO);
                            temp += (string.IsNullOrEmpty(temp) ? ""
                                    : (String.IsNullOrEmpty(oTL.NGAY + "") ? "" : " - ngày ")) + (String.IsNullOrEmpty(oTL.NGAY + "") ? "" : ((DateTime)oTL.NGAY).ToString("dd/MM/yyyy", cul));

                            nguoiky = (string.IsNullOrEmpty(oTL.NGUOIKY) ? "" : "<span style='margin-left: 5px;'>người ký: " + oTL.NGUOIKY + "</span>");
                            tt_nguoikhieunai = string.IsNullOrEmpty(oTL.NGUOINHAN) ? "" : "<span style='margin-left: 5px;'> cho: </span>" + oTL.NGUOINHAN;

                            if (!String.IsNullOrEmpty(oTL.DONID + ""))
                            {
                                tt_nguoikhieunai += string.IsNullOrEmpty(tt_nguoikhieunai + "") ? "" : " ";
                                if (oTL.DONID > 0)
                                {
                                    oDon = dt.GDTTT_DON.Where(x => x.ID == oTL.DONID).Single();
                                    if (oDon != null)
                                    {
                                        tt_nguoikhieunai += "<span style='margin-left: 5px;'>(";
                                        tt_nguoikhieunai += String.IsNullOrEmpty(oDon.TL_SO + "") ? "" : "Số " + oDon.TL_SO;
                                        tt_nguoikhieunai += (string.IsNullOrEmpty(tt_nguoikhieunai) ? ""
                                                  : (String.IsNullOrEmpty(oDon.TL_NGAY + "") ? "" : " ngày " + ((DateTime)oDon.TL_NGAY).ToString("dd/MM/yyyy", cul)));
                                        tt_nguoikhieunai += "</span>)";
                                    }
                                }
                                
                            }

                            //------------------------------
                            StrDisplay += "<div class='row_info'>";
                            StrDisplay += "<div style= 'float: left;width:100%; vertical-align: top;' >" + "<b>Trả lời đơn:</b> " + temp;
                            StrDisplay += "" + nguoiky;
                            StrDisplay += "" + tt_nguoikhieunai;
                            StrDisplay += "</div>";
                        }
                    }

                    lttGQDThongTin.Text = StrDisplay;

                }                
                else
                {
                    pnDetailKQ.Visible = true;
                    temp = (String.IsNullOrEmpty(oVA.GDQ_SO + "")) ? "" : "số <b>" + oVA.GDQ_SO + "</b>"
                                    + ((string.IsNullOrEmpty(oVA.GDQ_NGAY + "") || oVA.GDQ_NGAY == DateTime.MinValue) ? "" : "  ngày <b>" + ((DateTime)oVA.GDQ_NGAY).ToString("dd/MM/yyyy", cul) + "</b>");
                    if (temp != "")
                        lttGQDThongTin.Text = "<span style='margin-left:5px;'>" + temp + "</span>";

                    //----------nguoi ky- tham quyen xx---------------
                    temp = "";
                    string nguoiky = (oVA.GDQ_NGUOIKY + "").Trim();
                    //Decimal temp_id = (string.IsNullOrEmpty(oVA.THAMQUYENXXGDT + "")) ? 0 : (decimal)oVA.THAMQUYENXXGDT;
                    //if (temp_id > 0)
                    //    temp = " (" + dt.DM_TOAAN.Where(x => x.ID == temp_id).Single().MA_TEN + ")";
                    if (!string.IsNullOrEmpty(nguoiky))
                        lttGQDThongTin.Text += "<span style='margin-left:10px;'>Người ký: " + nguoiky + temp + "</span>";
                    string VKS_NC = "";
                    switch (kq)
                    {
                        //case 0:
                        //    #region tra loi don
                        //    lttLoaiKQ.Text = "Trả lời đơn";
                        //    #endregion
                        //    break;
                        case 1:
                            #region Khang nghi
                            int is_kn_vks = String.IsNullOrEmpty(oVA.ISVIENTRUONGKN + "") ? 0 : Convert.ToInt16(oVA.ISVIENTRUONGKN);
                            lttLoaiKQ.Text = "<b>Kháng nghị " + ((is_kn_vks == 0) ? "(CA)" : "(VKS)") + "</b>";
                            if (oVA.TRUONGHOPTHULY == 8 || oVA.TRUONGHOPTHULY == 10)
                            {
                                lttLoaiKQ.Text = "Không chấp nhận khiếu nại : ";
                            }
                            #endregion
                            break;
                        case 2:
                            lttLoaiKQ.Text = "<b>Xếp đơn : </b>";
                            break;
                        case 3:
                            #region XLK
                            VKS_NC = (String.IsNullOrEmpty(oVA.GQD_KETQUA + "")) ? "" : oVA.GQD_KETQUA + "</b>";
                            lttLoaiKQ.Text = "<b>Sử lý khác : </b>"
                                + VKS_NC;
                            if (oVA.TRUONGHOPTHULY == 8 || oVA.TRUONGHOPTHULY == 10)
                            {
                                lttLoaiKQ.Text = VKS_NC;
                            }
                            #endregion
                            break;
                        case 4:
                            #region VKS đang nghien cứa
                            VKS_NC = (String.IsNullOrEmpty(oVA.GQD_KETQUA + "")) ? "" : oVA.GQD_KETQUA + "</b>";
                            lttLoaiKQ.Text = "<b>VKS đang giải quyết</b>"
                                + VKS_NC;
                            #endregion
                            break;
                    }
                    //lttLoaiKQ.Text += ":";
                    //---------------------------
                    temp = "";
                    temp = (string.IsNullOrEmpty(oVA.GQD_NGAYPHATHANHCV + "") || oVA.GQD_NGAYPHATHANHCV == DateTime.MinValue) ? "" : ((DateTime)oVA.GQD_NGAYPHATHANHCV).ToString("dd/MM/yyyy", cul);
                    if (temp != "")
                        lttGQDThongTin.Text += (String.IsNullOrEmpty(temp + "") ? "" : (seperate_string + "Ngày phát hành: <b>" + temp + "</b>"));
                    //---------------------------
                    string ghichu = (string.IsNullOrEmpty(oVA.GQD_GHICHU + "")) ? "" : oVA.GQD_GHICHU.Trim();
                    if ((ghichu != "") || (temp != ""))
                        lttGQDThongTin.Text += (string.IsNullOrEmpty(oVA.GQD_GHICHU + "")) ? "" : "<br/>Ghi chú: " + ghichu + "";
                }
            }
            else
                pnGQD.Visible = false;
        }
        void Load_AnQuocHoi(Decimal VuAnID)
        {
            Decimal NhomAnQH = 1023;
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            //DataTable tbl = oBL.DANHSACHDONTHEOVuAnID(VuAnID);
            //lay cac đon co loai= CV+don , trang thai = da nhan theo vu an id
            DataTable tbl = oBL.GetAllByVuAn_TrangThaiChuyenDon(VuAnID, 2, 3, NhomAnQH);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptCQChuyenDonQH.DataSource = tbl;
                rptCQChuyenDonQH.DataBind();
                pnAnQH.Visible = true;
            }
        }
        void Load_AnChiDao(Decimal VuAnID)
        {
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DataTable tbl = oBL.DANHSACHDONCHIDAO_ByVuAnID(VuAnID, 2);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptChiDao.DataSource = tbl;
                rptChiDao.DataBind();
                pnAnChiDao.Visible = true;
            }
        }
        void Load_TTV_LanhDao(GDTTT_VUAN obj)
        {
            String temp_str = "";
            decimal temp_id = 0;
            #region ---------thong tin TTV/LD----------------

            #region Thông tin TTV/lanh dao
            DM_CANBO objCB = null;
            //-------------------------------
            temp_id = (string.IsNullOrEmpty(obj.THAMPHANID + "")) ? 0 : (decimal)obj.THAMPHANID;
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                lttTP.Text = objCB.HOTEN;
            }
            //----------------------------
            temp_id = (String.IsNullOrEmpty(obj.THAMTRAVIENID + "")) ? 0 : Convert.ToDecimal(obj.THAMTRAVIENID);
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                lttTTV.Text = objCB.HOTEN;
            }
            //-----------------
            temp_id = (String.IsNullOrEmpty(obj.LANHDAOVUID + "")) ? 0 : Convert.ToDecimal(obj.LANHDAOVUID);
            if (temp_id > 0)
            {
                objCB = dt.DM_CANBO.Where(x => x.ID == temp_id).Single();
                lttLD.Text = objCB.HOTEN;
            }
            #endregion

            //-----------Ngay TTV Nhan THS----------------------
            temp_str = (String.IsNullOrEmpty(obj.NGAYTTVNHAN_THS + "") || (obj.NGAYTTVNHAN_THS == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTTVNHAN_THS).ToString("dd/MM/yyyy", cul);
            lttNgayTTVNhanTHS.Text = temp_str;

            //-----------Ngay TTV Nhan THS----------------------
            temp_str = "";// (String.IsNullOrEmpty(obj.NGAYNHANHOSO + "") || (obj.NGAYNHANHOSO == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYNHANHOSO).ToString("dd/MM/yyyy", cul);            
            if (String.IsNullOrEmpty(temp_str))
            {
                int page_size = 30000;
                int pageindex = 1;
                int loaiphieu = 3;
                GDTTT_QUANLYHS_BL objBL = new GDTTT_QUANLYHS_BL();
                DataTable tblPhieuNhan = objBL.GetByVuAn_LoaiPhieu(VuAnID, loaiphieu, pageindex, page_size);
                if (tblPhieuNhan != null && tblPhieuNhan.Rows.Count > 0)
                {
                    DataRow rowPN = tblPhieuNhan.Rows[0];
                    temp_str = (String.IsNullOrEmpty(rowPN["SoPhieu"] + "") ? "" : ("Số " + rowPN["SoPhieu"].ToString()))
                                + (String.IsNullOrEmpty(rowPN["NGAYTAo"] + "") ? "" : (" ngày " + rowPN["NGAYTAo"].ToString()));
                }
            }
            lttNgayTTVNhanHS.Text = temp_str;
            // pnTTVNhanHS.Visible = !String.IsNullOrEmpty(temp_str);

            #endregion
        }
        void LoadBiCao(Decimal VuAnID)
        {
            string tucachtt = ENUM_DANSU_TUCACHTOTUNG.BIDON;
            string StrDisplay = "";
            GDTTT_VUANVUVIEC_DUONGSU_BL objBL = new GDTTT_VUANVUVIEC_DUONGSU_BL();
            DataTable tbl = objBL.AnHS_GetAllByLoaiDuongSu2(VuAnID, 1, 0);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                String temp = "";
                string bc_dauvu = "";
                foreach (DataRow row in tbl.Rows)
                {
                    bc_dauvu = Convert.ToInt16(row["HS_BiCanDauVu"] + "") == 1 ? " (đầu vụ)" : "";
                    ////------------------------------
                    temp = "<div class='row_info'>";
                    temp += "<div class='cell_info'>" + row["TenDuongSu"].ToString() + bc_dauvu;
                    temp += String.IsNullOrEmpty(row["HS_TenToiDanh"] + "") ? "" : " -<span class='margin_left'>" + row["HS_TenToiDanh"].ToString() + "</span>";
                    temp += String.IsNullOrEmpty(row["HS_MucAn"] + "") ? "" : ";<span class='margin_left'> Mức án: " + row["HS_MucAn"].ToString() + "</span></div>";
                    temp += "</div>";
                    //------------------------------
                    StrDisplay += temp;
                }
            }
            lttBiAn.Text = StrDisplay;
        }

        //----------------------------------
        #region Load quan ly ho so
        void Load_QLHoSo()
        {
            int page_size = 30000;
            int pageindex = 1;
            int loaiphieu = -1;
            DataTable tblTemp = null;
            DataRow row_data = null;
            GDTTT_QUANLYHS_BL objBL = new GDTTT_QUANLYHS_BL();
            DataTable tbl = objBL.GetByVuAn_LoaiPhieu(VuAnID, loaiphieu, pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                tblTemp = tbl.Clone();
                loaiphieu = 0;//phieu muon
                DataRow[] arr = tbl.Select("LoaiPhieuID=" + loaiphieu);
                if (arr.Length > 0)
                {
                    tblTemp = arr.CopyToDataTable();
                    rptHoSo.DataSource = tblTemp;
                    rptHoSo.DataBind();
                    rptHoSo.Visible = true;
                }

                //-------------------
                loaiphieu = 1;//phieu tra hs
                arr = tbl.Select("LoaiPhieuID=" + loaiphieu, "");
                if (arr != null && arr.Length > 0)
                {
                    pnNgayTraHS.Visible = true;
                    row_data = arr[0];
                    lttNgayTraHS.Text = ((string.IsNullOrEmpty(row_data["SoPhieu"] + "")) ? "" : row_data["SoPhieu"].ToString())
                        + (string.IsNullOrEmpty(row_data["NgayTao"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["NgayTao"] + "</span>"))
                        + (string.IsNullOrEmpty(row_data["TenCanBo"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["TenCanBo"].ToString() + "</span>"))
                        + (string.IsNullOrEmpty(row_data["GhiChu"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["GhiChu"].ToString() + "</span>"));
                }
                else pnNgayTraHS.Visible = false;
                //-------------------
                loaiphieu = 2;//phieu chuyen hs
                arr = tbl.Select("LoaiPhieuID=" + loaiphieu, "");
                if (arr != null && arr.Length > 0)
                {
                    pnNgayChuyenHS.Visible = true;
                    row_data = arr[0];
                    lttNgayChuyenHS.Text = ((string.IsNullOrEmpty(row_data["SoPhieu"] + "")) ? "" : row_data["SoPhieu"].ToString())
                        + (string.IsNullOrEmpty(row_data["NgayTao"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["NgayTao"] + "</span>"))
                        + (string.IsNullOrEmpty(row_data["TenCanBo"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["TenCanBo"].ToString() + "</span>"))
                        + (string.IsNullOrEmpty(row_data["GhiChu"] + "") ? "" : ("<span style='margin-left:10px;'>" + row_data["GhiChu"].ToString() + "</span>"));
                }
                else pnNgayChuyenHS.Visible = false;
            }
            else
            {
                rptHoSo.Visible = false;
            }
        }
        #endregion
        //----------------------------------
        #region Load to trinh
        private void LoadToTrinh()
        {
            DataTable tbl = null;
            try
            {
                tbl = GetData_ToTrinh();
            }
            catch (Exception ex) { }
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptToTrinh.DataSource = tbl;
                rptToTrinh.DataBind();
                rptToTrinh.Visible = true;
            }
            else
                rptToTrinh.Visible = false;
        }
        DataTable GetData_ToTrinh()
        {
            DataTable tblTemp = null;
            DataRow newrow = null;
            string temp = "", tenlanhdao = "", trunggian = "";
            Decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            DataTable tbl = oBL.VUAN_TOTRINH(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                tblTemp = tbl.Clone();
                DataRow[] arr = tbl.Select("", "NgayTrinh asc, ThuTuCapTrinh asc");
                foreach (DataRow row in arr)
                {
                    temp = row["TENTINHTRANG"] + "";
                    
                    if (row["TinhTrangID"].ToString() == "12" || row["TinhTrangID"].ToString() == "11")
                    {
                        if (row["chucvuid"].ToString() == "74")
                            tenlanhdao = "PCA ";
                        else if (row["chucvuid"].ToString() == "45")
                            tenlanhdao = "CA ";
                        else
                            if (row["chucdanhid"].ToString() == "486")
                            tenlanhdao = "TP ";
                        else
                            tenlanhdao = "";
                        tenlanhdao = tenlanhdao + row["TENLANHDAO"] + "";
                    }
                    else
                        tenlanhdao = row["TENLANHDAO"] + "";
                    row["StrNgayTrinh"] = "Ngày trình: " + row["StrNgayTrinh"] + "";
                    //--------------------
                    newrow = tblTemp.NewRow();
                    foreach (DataColumn cl in tbl.Columns)
                        newrow[cl.ColumnName] = row[cl.ColumnName];

                    newrow["TENTINHTRANG"] = row["TENTINHTRANG"] + ""
                                        + (String.IsNullOrEmpty(tenlanhdao) ? "" : (" " + tenlanhdao));
                    tblTemp.Rows.Add(newrow);

                    //------------------------------
                    temp = row["NgayTra"] + "";
                    if (!String.IsNullOrEmpty(temp))
                    {
                        newrow = tblTemp.NewRow();
                        newrow["StrNgayTrinh"] = "Ngày trả: " + row["NgayTra"] + "";

                        temp = row["TENTINHTRANG"].ToString();
                        if (row["TinhTrangID"].ToString() == "12" || row["TinhTrangID"].ToString() == "11")
                        {
                            if (row["chucvuid"].ToString() == "74")
                                trunggian = "PCA ";
                            else if (row["chucvuid"].ToString() == "45")
                                trunggian = "CA ";
                            else
                                if (row["chucdanhid"].ToString() == "486")
                                trunggian = "TP ";
                            else
                                trunggian = "";
                            trunggian = trunggian + row["TENLANHDAO"] + "";
                            tenlanhdao = temp.Replace(row["TENTINHTRANG"] + "", trunggian);
                        }
                        else
                            tenlanhdao = temp.Replace("Trình ", "").Replace("Báo cáo ", "");

                        newrow["TENTINHTRANG"] = tenlanhdao + " cho ý kiến: "
                                + (String.IsNullOrEmpty(row["YKienLanhDao"] + "") ? "" : (row["YKienLanhDao"].ToString())) + " "
                                + (String.IsNullOrEmpty(row["CapTrinhTiep"] + "") ? "" : (row["CapTrinhTiep"].ToString())) + " "
                                + (String.IsNullOrEmpty(row["CapTrinhTiep"] + "") ? "" : "<br/>") + (row["YKIEN"] + "");
                        tblTemp.Rows.Add(newrow);
                    }
                }
            }
            return tblTemp;
        }

        #endregion

        void Load_HoanTHA(GDTTT_VUAN objVA)
        {
            string nguoiky = "", StrDisplay = "";
            int ishoanTHA = (String.IsNullOrEmpty(objVA.GQD_ISHOANTHA + "")) ? 0 : (int)objVA.GQD_ISHOANTHA;
            if (ishoanTHA > 0)
            {
                nguoiky = (string.IsNullOrEmpty(objVA.GQD_HOANTHA_TENNGUOIKY + "")) ? "" : ("Người ký <b>" + objVA.GQD_HOANTHA_TENNGUOIKY + "</b>");

                StrDisplay = (String.IsNullOrEmpty(objVA.GQD_HOANTHA_SO + "") || (objVA.GQD_HOANTHA_SO == " ")) ? "" : ("Số <b>" + objVA.GQD_HOANTHA_SO + "</b>");
                if (objVA.GQD_HOANTHA_NGAY != null)
                    StrDisplay += (String.IsNullOrEmpty(objVA.GQD_HOANTHA_NGAY + "")) ? "" : ("ngày <b>" + ((DateTime)objVA.GQD_HOANTHA_NGAY).ToString("dd/MM/yyyy", cul) + "</b>");

                if ((StrDisplay != "") && (nguoiky != ""))
                    StrDisplay += "<span style='margin-left:10px;'></span>";

                if (StrDisplay != "")
                    lttHoanTHA.Text = StrDisplay;
            }
            pnHoanTHA.Visible = !String.IsNullOrEmpty(StrDisplay);
        }
        void LoadDsThongBaoTT_TLDon()
        {
            GDTTT_DON_TRALOI_BL oBL = new GDTTT_DON_TRALOI_BL();

            //-----TB tinh the------------------
            DataTable tbl = oBL.GetThongBao(VuAnID, ENUM_LOAITHONGBAO_QH.TBTINHTHE);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptTBTT.DataSource = tbl;
                rptTBTT.DataBind();
                pnThongBaoTT.Visible = true;
            }

            //--------TB tra loi don----------------------------
            tbl = oBL.GetThongBao(VuAnID, ENUM_LOAITHONGBAO_QH.TBKQTRALOI);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rptTBTL.DataSource = tbl;
                rptTBTL.DataBind();
                pnThongBaoTL.Visible = true;
            }
        }
        //-------------------------
        #region Load xet xu GDTTT
        void Load_XetXuGDTTT(GDTTT_VUAN objVA)
        {
            Decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
            Load_ThuLyXXGDTTT(objVA);

            //----------------------------------
            GDTTT_VUAN_XETXU_BL objBL = new GDTTT_VUAN_XETXU_BL();
            DataTable tbl = objBL.XetXuGDTTT_GetByVuAnID(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataView view = new DataView(tbl);
                view.Sort = "NgayMoPhienToa asc";
                DataTable tblData = view.ToTable();

                rptXX.DataSource = tblData;
                rptXX.DataBind();
                pnXXGDT.Visible = true;
            }
            else
                pnXXGDT.Visible = false;
        }
        void Load_ThuLyXXGDTTT(GDTTT_VUAN objVA)
        {
            String StrDisplay = "", date_temp = "";
            String temp_so = (string.IsNullOrEmpty(objVA.SOTHULYXXGDT + "") ? "" : "Số <b>" + objVA.SOTHULYXXGDT.ToString() + "</b>");
            int is_kn_vks = String.IsNullOrEmpty(objVA.ISVIENTRUONGKN + "") ? 0 : Convert.ToInt16(objVA.ISVIENTRUONGKN);

            if (string.IsNullOrEmpty(objVA.NGAYTHULYXXGDT + "") || objVA.NGAYTHULYXXGDT == DateTime.MinValue)
                date_temp = "";
            else date_temp = "ngày <b>" + ((DateTime)objVA.NGAYTHULYXXGDT).ToString("dd/MM/yyyy", cul) + "</b>";
            StrDisplay = temp_so + (String.IsNullOrEmpty(date_temp + "") ? "" : "   ") + date_temp;
            if (StrDisplay != "")
            {
                if (is_kn_vks > 0)
                {
                    date_temp = "ngày <b>" + ((DateTime)objVA.VIENTRUONGKN_NGAY).ToString("dd/MM/yyyy", cul) + "</b>";
                    temp_so = (string.IsNullOrEmpty(objVA.VIENTRUONGKN_SO + "") ? "" : "số <b>" + objVA.VIENTRUONGKN_SO.ToString() + "</b>");
                    if (!string.IsNullOrEmpty(temp_so))
                        temp_so += " ";
                    temp_so += date_temp;

                    StrDisplay += " do Chánh án/Viện trưởng KN theo " + temp_so;
                }
            }
            lttThuLyXXGDTTT.Text = StrDisplay;
            pnNgayThuLyXXGDT.Visible = !String.IsNullOrEmpty(StrDisplay);

            //-------------------------------
            date_temp = (string.IsNullOrEmpty(objVA.XXGDTTT_NGAYVKSTRAHS + "") || objVA.XXGDTTT_NGAYVKSTRAHS == DateTime.MinValue) ? "" : ((DateTime)objVA.XXGDTTT_NGAYVKSTRAHS).ToString("dd/MM/yyyy", cul);
            pnNgayNhanHSTuVKS.Visible = !String.IsNullOrEmpty(date_temp);
            lttNgayNhanHS_VKS.Text = date_temp;
        }
        #endregion

        //protected void cmdReLoad_Click(object sender, EventArgs e)
        //{
        //  //  Decimal VuAnID = String.IsNullOrEmpty(Request["vid"] + "") ? 0 : Convert.ToDecimal(Request["vid"] + "");
        //    if (VuAnID > 0)
        //    {
        //        LoadThongTinVuAn();
        //    }
        //}
        protected void cmdPrintContent_Click(object sender, EventArgs e)
        {
            System.IO.StringWriter sw = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter h = new System.Web.UI.HtmlTextWriter(sw);
            zone_vuan_info.RenderControl(h);
            string CONTENT = sw.GetStringBuilder().ToString();

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string strPBID = Session[ENUM_SESSION.SESSION_PHONGBANID] + "";
            Int32 PBID = strPBID == "" ? 0 : Convert.ToInt32(strPBID);
            object Result = new object();

            Literal Table_Str_Totals = new Literal();

            //string CONTENT = Request["zone_vuan_info"].ToString();
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=BC_THONGTINVUAN_GDKT.doc");
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
                                          "font-size:13.0pt;}");

            Response.Write("@page Section1 {size:595.45pt 841.7pt; margin:0.7874015748in 0.5905511811in 0.7086614173in 1.18in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");
            Response.Write("div.Section1 {page:Section1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:1.25in 1.0in 1.25in 1.0in;mso-header-margin:.5in;mso-footer-margin:.5in;mso-paper-source:0;}");         
            Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header: h1;mso-header-margin:.0in;mso-footer-margin:.3in;mso-paper-source:0;mso-footer: f1;}");
            //Response.Write("@page Section2 {size:841.7pt 595.45pt;mso-page-orientation:landscape;margin:0.5in 1.0in 0.5in 1.0in;mso-header-margin:.1in;mso-footer-margin:.1in;mso-paper-source:0;}");
            Response.Write("div.Section2 {page:Section2;}");

              
            Response.Write("</style>");
            Response.Write("<style type=text/css>" +
                " body { width: 98 %; margin-left: 1 %; min-width: 0px; overflow-y: auto; overflow-x: auto;}" +
                ".row_info {float: left; width: 100 %; vertical-align: top; margin-bottom: 3px;}" +
                ".cell_info {float: left; vertical-align: top;}" +
                ".margin_left {margin-left: 5px;}" +
                ".table_info_va {border: solid 1px #a2c2a8;border-collapse: collapse;margin: 5px 0;width: 100 %;font-size:13.0pt;}" +
                ".table_info_va td{border: solid 1px #a2c2a8;padding: 5px;line-height: 17px;text-align: left;vertical-align: middle;}" +
                ".col1 {width: 215px;font-weight: bold;}" +
                ".table_tt {border: none;border-collapse: collapse;margin: 5px 0;width: 100 %;}" +
                ".table_tt td {padding: 5px;border: none;line-height: 17px; text-align: left;vertical-align: middle;}" +
                ".table_tt td:first-child {padding-left: 0px;}" +
                "</ style >");


            Response.Write("</head>");
            Response.Write("<body>");
            Response.Write("<div class=Section2>");
            System.IO.StringWriter stringWrite = new System.IO.StringWriter();
            System.Web.UI.HtmlTextWriter htmlWrite = new HtmlTextWriter(stringWrite);
            htmlWrite.WriteLine("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">");
            htmlWrite.WriteLine(CONTENT);

            Table_Str_Totals.RenderControl(htmlWrite);
            Response.Write(stringWrite.ToString());
            Response.Write("<div style=\"text-align:right; font-family:Times New Roman;font-size:10pt;font-style: italic;\"> Ngày xuất báo cáo:" + Convert.ToString(DateTime.Today) +"</div>");
            Response.Write("</div>");
            Response.Write("</body>");
            Response.Write("</html>");
            Response.End();
        }
    }

}
