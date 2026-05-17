using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using WEB.GSTP.QLAN.GDTTT.In;
using BL.GSTP.BANGSETGET;
using BL.GSTP.GDTTT;

namespace WEB.GSTP.QLAN.GDTTT.PCTP
{
    public partial class CapnhatKetqua : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrUserID = 0;
        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        public string GetDate(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return "";
                else
                    return Convert.ToDateTime(obj).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            { return ""; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            scriptManager.RegisterPostBackControl(this.btnNBInDSTP);
            if (!IsPostBack)
            {
                try
                {
                    DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
                    DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
                    ddlToaXetXu.DataSource = dtTA;
                    ddlToaXetXu.DataTextField = "MA_TEN";
                    ddlToaXetXu.DataValueField = "ID";
                    ddlToaXetXu.DataBind();
                    ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));

                    //Load Thẩm phán
                    string vLoai = Request["type"] + "";
                    if (vLoai == "VUANKN") //chỉ cho chọn thẩm phán tối cao
                    {
                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                        ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "0", 0);
                        ddlThamphan.DataTextField = "hotenngaysinh";
                        ddlThamphan.DataValueField = "ID";
                        ddlThamphan.DataBind();
                    }
                    else
                    {
                        GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();

                        DataTable tptc = oGDTBL.THAMPHAN_GETBY_NC(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), "0", 0);
                        DataTable tpb3 = oGDTBL.THAMPHAN_GETBY_NC(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), "1", 0);
                        tptc.Merge(tpb3);
                        tptc.AcceptChanges();

                        ddlThamphan.DataSource = tptc;
                        ddlThamphan.DataTextField = "hotenngaysinh";
                        ddlThamphan.DataValueField = "ID";
                        ddlThamphan.DataBind();

                        //DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                        //ddlThamphan.DataSource = oCBDT;
                        //ddlThamphan.DataTextField = "HOTEN";
                        //ddlThamphan.DataValueField = "ID";
                        //ddlThamphan.DataBind();
                    }
                    ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));
                    Load_Data();

                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                }
                catch (Exception exx) { lblThongbao.Text = exx.Message; }
            }
        }

        protected void btnNBInDSTP_Click(object sender, EventArgs e)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            string strID = Request["kqid"] + "";
            decimal KQID = Convert.ToDecimal(strID);
            decimal ToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue),
               vThamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);
            string SoBAQD = txtSoQDBA.Text.Trim(), NgayBAQD = txtNgayBAQD.Text, NguoiGui = txtNguoigui.Text.Trim(),
                vSoThuly = txtThuly_So.Text.Trim(), vNgayThuly = txtThuly_Ngay.Text;
            //------------------
            Literal Table_Str_Totals = new Literal();
            DataTable tbl = new DataTable();
            DataRow row = tbl.NewRow();
            //-------------
            tbl = oBL.DON_GETTHEOKETQUAID_EXPORT(ToaAnID, KQID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui, vNgayThuly, vSoThuly, vThamphanID);
            //-----------
            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                Table_Str_Totals.Text = row["TEXT_REPORT"] + "";
            }
            //--------------------------
            Response.Clear();
            Response.AddHeader("content-disposition", "attachment;filename=DS_DON_TP_GQ.doc");
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
            Response.Write("<div class=Section2>");//chỉ định khổ giấy
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

        private DataTable getDS()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            string strID = Request["kqid"] + "";
            string hinhthuc = Request["hinhthuc"] + "";
            string vLoai = Request["type"] + "";
            if (strID == "") return null;
            if (hinhthuc == "") return null;
            decimal KQID = Convert.ToDecimal(strID);
            decimal vHinhThuc = Convert.ToDecimal(hinhthuc);
            decimal ToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue), vThamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);
            string SoBAQD = txtSoQDBA.Text.Trim(), NgayBAQD = txtNgayBAQD.Text, NguoiGui = txtNguoigui.Text.Trim(), vSoThuly = txtThuly_So.Text.Trim(), vNgayThuly = txtThuly_Ngay.Text;

            //lấy kết quả hình thức phân công ngẫu nhiên
            if (vHinhThuc == 0)
            {
                if (vLoai == "VUANKN")
                    return oBL.GET_THEOKETQUAID_PHANCONGNGAUNHIEN_VAKN(ToaAnID, KQID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui, vNgayThuly, vSoThuly, vThamphanID); //vụ án kháng nghị
                else
                    return oBL.DON_GETTHEOKETQUAID(ToaAnID, KQID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui, vNgayThuly, vSoThuly, vThamphanID); // đơn
            }
            else
            {
                if (vLoai == "VUANKN")
                    return oBL.VAKN_GET_THEO_KETQUA_CHIDINHID(ToaAnID, null, null, 0, 0, 0, null, null, 0, KQID); //lấy loại là vụ án kháng nghị phân công chỉ định
                else
                    return oBL.DON_GETTHEOKETQUAID_CHIDINH(ToaAnID, KQID, ToaRaBAQD, SoBAQD, NgayBAQD, NguoiGui, vNgayThuly, vSoThuly, vThamphanID, null); //lấy kết quả hình thức phân công chỉ định
            }
        }

        protected void Load_Data()
        {
            DataTable oDT = getDS();
            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(oDT.Rows.Count, Convert.ToInt32(ddlPageCount.SelectedValue)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> đơn trong <b>" + hddTotalPage.Value + "</b> trang";
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

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("KetQuaPhancong.aspx");

        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            string hinhthuc = Request["hinhthuc"] + "";
            string type = Request["type"] + "";
            decimal vHinhThuc = Convert.ToDecimal(hinhthuc);
            if (vHinhThuc != 1 && vHinhThuc != 0)
            {
                lblThongbao.Text = "Có lỗi xảy ra khi lưu";
            }

            int count_update = 0;
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    TextBox txtNgayPhanCongTP = (TextBox)Item.FindControl("txtNgayPhanCongTP");
                    DropDownList ddlThamphan = (DropDownList)Item.FindControl("ddlThamphan");
                    TextBox txtLyDo = (TextBox)Item.FindControl("txtGhichu");
                    TextBox txtSoTT = (TextBox)Item.FindControl("txtSoTT");
                    TextBox txtNgayToTrinh = (TextBox)Item.FindControl("txtNgayToTrinh");

                    string strID = Item.Cells[0].Text;
                    decimal ID = Convert.ToDecimal(strID);

                    //hình thức phân công ngẫu nhiên
                    if (vHinhThuc == 0)
                    {
                        if (type == "VUANKN")
                        {
                            GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET oTCD = dt.GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET.Where(x => x.ID == ID).FirstOrDefault();

                            //kiểm tra vụ án đã chuyển TP chưa, nếu chuyển r thì không được sửa phân công
                            GDTTT_DON_BL oPCBL = new GDTTT_DON_BL();
                            if (oPCBL.CHECK_VAKN_CHUYENTP_XOA_PHANCONG_NGAUNHIEN(oTCD.NGAUNHIENID ?? 0))
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Có vụ án đã được chuyển thẩm phán tối cao, bạn sẽ không được phép sửa kết quả phân công!');", true);
                                return;
                            }

                            String strMsg = "";
                            if (oTCD.CANBOID.ToString() == ddlThamphan.SelectedValue)
                            {
                                strMsg = "Bạn chưa chọn Thẩm phán";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                ddlThamphan.Focus();
                                break;
                            }
                            else if (Convert.ToDecimal(ddlThamphan.SelectedValue) == 0)
                            {
                                strMsg = "Bạn chưa chọn Thẩm phán";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                ddlThamphan.Focus();
                                break;
                            }
                            else if (txtNgayPhanCongTP.Text == "")
                            {
                                strMsg = "Bạn chưa chọn Ngày phân công TP";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                txtNgayPhanCongTP.Focus();
                                break;
                            }
                            else if (txtLyDo.Text == "")
                            {
                                strMsg = "Bạn chưa nhập Lý do thay đổi";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                txtLyDo.Focus();
                                break;
                            }
                            else
                            {
                                if (oTCD.CANBOID.ToString() != ddlThamphan.SelectedValue && oTCD.CANBOID != null && oTCD.CANBOID != 0)
                                {
                                    //luu vao bang GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET
                                    oTCD.CANBOID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                                    oTCD.ISCHANGE = 1;
                                    oTCD.GHICHU = txtLyDo.Text;
                                    oTCD.NGAYPHANCONGTP = DateTime.ParseExact(txtNgayPhanCongTP.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                                    //Lưu lại vào bảng GDTTT_VUAN_CHITIET_CHUYEN
                                    GDTTT_VUAN_CHITIET_CHUYEN oVu = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == oTCD.VUANID && x.TRANGTHAI == 2 && x.THAMPHANID > 0).FirstOrDefault();
                                    oVu.THAMPHANID = oTCD.CANBOID;
                                    dt.SaveChanges();
                                    count_update++;
                                }
                            }
                        }
                        else
                        {
                            GDTTT_PCTP_CHITIET oT = dt.GDTTT_PCTP_CHITIET.Where(x => x.ID == ID).FirstOrDefault();
                            if (oT != null)
                            {
                                String strMsg = "";
                                if (oT.CANBOID.ToString() == ddlThamphan.SelectedValue)
                                {
                                    strMsg = "Bạn chưa chọn Thẩm phán";
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    ddlThamphan.Focus();
                                    break;
                                }
                                else if (Convert.ToDecimal(ddlThamphan.SelectedValue) == 0)
                                {
                                    strMsg = "Bạn chưa chọn Thẩm phán";
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    ddlThamphan.Focus();
                                    break;
                                }
                                else if (txtNgayPhanCongTP.Text == "")
                                {
                                    strMsg = "Bạn chưa chọn Ngày phân công TP";
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    txtNgayPhanCongTP.Focus();
                                    break;
                                }
                                else if (txtLyDo.Text == "")
                                {
                                    strMsg = "Bạn chưa nhập Lý do thay đổi";
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    txtLyDo.Focus();
                                    break;
                                }
                                else if (txtSoTT.Text == "")
                                {
                                    strMsg = "Bạn chưa nhập Số tờ trình";
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    txtSoTT.Focus();
                                    break;
                                }
                                else if (txtNgayToTrinh.Text == "")
                                {
                                    strMsg = "Bạn chưa nhập Ngày tờ trình";
                                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                    txtNgayToTrinh.Focus();
                                    break;
                                }
                                else
                                {
                                    if (oT.CANBOID.ToString() != ddlThamphan.SelectedValue && oT.CANBOID != null && oT.CANBOID != 0)
                                    {
                                        //Update lich su phân công Thẩm phán
                                        UpdateHistory_PCTP_DON(ID, txtLyDo.Text, 1, Convert.ToDecimal(ddlThamphan.SelectedValue)
                                                            , DateTime.ParseExact(txtNgayPhanCongTP.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture), txtSoTT.Text, DateTime.ParseExact(txtNgayToTrinh.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture), CurrUserID);

                                        //luu vao bang GDTTT_PCTP_CHITIET
                                        oT.CANBOID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                                        oT.ISCHANGE = 1;
                                        oT.GHICHU = txtLyDo.Text;
                                        oT.NGAYPHANCONGTP = DateTime.ParseExact(txtNgayPhanCongTP.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                                        //Lưu lại vào đơn
                                        GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == oT.DONID).FirstOrDefault();
                                        oDon.THAMPHANID = oT.CANBOID;
                                        oDon.CD_SOTOTRINH = txtSoTT.Text;
                                        oDon.CD_NGAYTOTRINH = DateTime.ParseExact(txtNgayToTrinh.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                                        dt.SaveChanges();
                                        count_update++;
                                    }
                                }
                            }
                        }
                    }
                    else // hình thức chỉ định
                    {
                        if (type == "VUANKN")
                        {
                            GDTTT_PCTP_VAKN_CHIDINH_CHITIET oTCD = dt.GDTTT_PCTP_VAKN_CHIDINH_CHITIET.Where(x => x.ID == ID).FirstOrDefault();

                            //kiểm tra vụ án đã chuyển TP chưa, nếu chuyển r thì không được sửa phân công
                            GDTTT_DON_BL oPCBL = new GDTTT_DON_BL();
                            if (oPCBL.CHECK_VAKN_CHUYENTP_XOA_PHANCONG_CHIDINH(oTCD.CHIDINHID ?? 0))
                            {
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Có vụ án đã được chuyển thẩm phán tối cao, bạn sẽ không được phép sửa kết quả phân công!');", true);
                                return;
                            }

                            String strMsg = "";
                            if (oTCD.CANBOID.ToString() == ddlThamphan.SelectedValue)
                            {
                                strMsg = "Bạn chưa chọn Thẩm phán";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                ddlThamphan.Focus();
                                break;
                            }
                            else if (Convert.ToDecimal(ddlThamphan.SelectedValue) == 0)
                            {
                                strMsg = "Bạn chưa chọn Thẩm phán";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                ddlThamphan.Focus();
                                break;
                            }
                            else if (txtNgayPhanCongTP.Text == "")
                            {
                                strMsg = "Bạn chưa chọn Ngày phân công TP";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                txtNgayPhanCongTP.Focus();
                                break;
                            }
                            else if (txtLyDo.Text == "")
                            {
                                strMsg = "Bạn chưa nhập Lý do thay đổi";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                txtLyDo.Focus();
                                break;
                            }
                            else
                            {
                                if (oTCD.CANBOID.ToString() != ddlThamphan.SelectedValue && oTCD.CANBOID != null && oTCD.CANBOID != 0)
                                {
                                    //luu vao bang GDTTT_PCTP_VAKN_CHIDINH_CHITIET
                                    oTCD.CANBOID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                                    oTCD.ISCHANGE = 1;
                                    oTCD.GHICHU = txtLyDo.Text;
                                    oTCD.NGAYPHANCONGTP = DateTime.ParseExact(txtNgayPhanCongTP.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                                    //Lưu lại vào bảng GDTTT_VUAN_CHITIET_CHUYEN
                                    GDTTT_VUAN_CHITIET_CHUYEN oVu = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == oTCD.VUANID && x.TRANGTHAI == 2 && x.THAMPHANID > 0).FirstOrDefault();
                                    oVu.THAMPHANID = oTCD.CANBOID;
                                    dt.SaveChanges();
                                    count_update++;
                                }
                            }
                        }
                        else
                        {
                            GDTTT_PCTP_CHITIET_CHIDINH oTCD = dt.GDTTT_PCTP_CHITIET_CHIDINH.Where(x => x.ID == ID).FirstOrDefault();
                            String strMsg = "";
                            if (oTCD.CANBOID.ToString() == ddlThamphan.SelectedValue)
                            {
                                strMsg = "Bạn chưa chọn Thẩm phán";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                ddlThamphan.Focus();
                                break;
                            }
                            else if (Convert.ToDecimal(ddlThamphan.SelectedValue) == 0)
                            {
                                strMsg = "Bạn chưa chọn Thẩm phán";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                ddlThamphan.Focus();
                                break;
                            }
                            else if (txtNgayPhanCongTP.Text == "")
                            {
                                strMsg = "Bạn chưa chọn Ngày phân công TP";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                txtNgayPhanCongTP.Focus();
                                break;
                            }
                            else if (txtLyDo.Text == "")
                            {
                                strMsg = "Bạn chưa nhập Lý do thay đổi";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                txtLyDo.Focus();
                                break;
                            }
                            else if (txtSoTT.Text == "")
                            {
                                strMsg = "Bạn chưa nhập Số tờ trình";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                txtSoTT.Focus();
                                break;
                            }
                            else if (txtNgayToTrinh.Text == "")
                            {
                                strMsg = "Bạn chưa nhập Ngày tờ trình";
                                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "')", true);
                                txtNgayToTrinh.Focus();
                                break;
                            }
                            else
                            {
                                if (oTCD.CANBOID.ToString() != ddlThamphan.SelectedValue && oTCD.CANBOID != null && oTCD.CANBOID != 0)
                                {
                                    //Update lich su phân công Thẩm phán
                                    UpdateHistory_PCTP_DON_CHI_DINH(ID, txtLyDo.Text, 1, Convert.ToDecimal(ddlThamphan.SelectedValue)
                                                        , DateTime.ParseExact(txtNgayPhanCongTP.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture), txtSoTT.Text, DateTime.ParseExact(txtNgayToTrinh.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture), CurrUserID);

                                    //luu vao bang GDTTT_PCTP_CHITIET
                                    oTCD.CANBOID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                                    oTCD.ISCHANGE = 1;
                                    oTCD.GHICHU = txtLyDo.Text;
                                    oTCD.NGAYPHANCONGTP = DateTime.ParseExact(txtNgayPhanCongTP.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                                    //Lưu lại vào đơn
                                    GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == oTCD.DONID).FirstOrDefault();
                                    oDon.THAMPHANID = oTCD.CANBOID;
                                    oDon.CD_SOTOTRINH = txtSoTT.Text;
                                    oDon.CD_NGAYTOTRINH = DateTime.ParseExact(txtNgayToTrinh.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                                    dt.SaveChanges();
                                    count_update++;
                                }
                            }
                        }
                    }
                }
            }
            if (count_update > 0)
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                Load_Data();
                lblThongbao.Text = "Hoàn thành lưu !";
            }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    DropDownList ddlThamphan = (DropDownList)e.Item.FindControl("ddlThamphan");
                    GDTTT_DON_BL oDMCBBL = new GDTTT_DON_BL();
                    GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                    decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                    string vLoai = Request["type"] + "";
                    if (vLoai == "VUANKN") //chỉ cho chọn thẩm phán tối cao
                    {
                        ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "0", 0);
                        ddlThamphan.DataTextField = "hotenngaysinh";
                        ddlThamphan.DataValueField = "ID";
                        ddlThamphan.DataBind();
                    }
                    else
                    {
                        HiddenField hddCurrISTPB3 = (HiddenField)e.Item.FindControl("hddCurrISTPB3");

                        //là thẩm phán bậc 3
                        if (hddCurrISTPB3.Value == "1")
                        {
                            ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "1", 0);
                            ddlThamphan.DataTextField = "hotenngaysinh";
                            ddlThamphan.DataValueField = "ID";
                            ddlThamphan.DataBind();
                        }
                        else
                        {
                            //là thẩm phán tối cao
                            ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "0", 0);
                            ddlThamphan.DataTextField = "hotenngaysinh";
                            ddlThamphan.DataValueField = "ID";
                            ddlThamphan.DataBind();
                        }
                    }

                    HiddenField hddTPID = (HiddenField)e.Item.FindControl("hddTPID");
                    HiddenField hddTPIDSua = (HiddenField)e.Item.FindControl("hddTPIDSua");
                    string strID = "";
                    if (hddTPID.Value != "" && hddTPIDSua.Value == "")
                    {
                        strID = hddTPID.Value;
                    }
                    else strID = hddTPIDSua.Value;
                    ddlThamphan.SelectedValue = strID;

                    DataRowView rv = (DataRowView)e.Item.DataItem;
                    //----------------------------- 

                    HiddenField hddCurrID = (HiddenField)e.Item.FindControl("hddCurrID");
                    TextBox txtNgayPhanCongTP = (TextBox)e.Item.FindControl("txtNgayPhanCongTP");
                    TextBox txtGhichu = (TextBox)e.Item.FindControl("txtGhichu");
                    TextBox txtSoTT = (TextBox)e.Item.FindControl("txtSoTT");
                    TextBox txtNgayToTrinh = (TextBox)e.Item.FindControl("txtNgayToTrinh");

                    Literal lttTP = (Literal)e.Item.FindControl("lttTP");
                    //--------------------------------------
                    CheckBox chk = (CheckBox)e.Item.FindControl("chkChon");
                    if (chk.Checked)
                    {
                        ddlThamphan.Visible = true;
                        lttTP.Visible = false;
                        txtSoTT.Enabled = txtNgayToTrinh.Enabled = txtGhichu.Enabled = txtNgayPhanCongTP.Enabled = true;
                    }
                    else
                    {
                        ddlThamphan.Visible = false;
                        lttTP.Visible = true;
                        txtSoTT.Enabled = txtNgayToTrinh.Enabled = txtGhichu.Enabled = txtNgayPhanCongTP.Enabled = false;
                    }

                    int count = 0;
                    string StrDisplay = "", temp = "";
                    string[] arr = null;
                    Decimal CurrVuAnID = Convert.ToDecimal(hddCurrID.Value);
                    String PhanCongTP = rv["PhanCongTP"] + "";
                    String lttHistory_TP = "";
                    StrDisplay = "";
                    if (!String.IsNullOrEmpty(PhanCongTP))
                    {
                        lttHistory_TP += "<b>- " + rv["TENTHAMPHAN"] + ((String.IsNullOrEmpty(rv["NGAYPHANCONGTP"] + "") || rv["NGAYPHANCONGTP"].ToString() == "01/01/0001") ? "" : (" (" + (rv["NGAYPHANCONGTP"]).ToString() + ")")) + "</b>";
                        arr = PhanCongTP.Split("*".ToCharArray());
                        foreach (String str in arr)
                        {
                            if (str != "")
                            {
                                temp = txtNgayPhanCongTP.Text;
                                if (count == 0)
                                    StrDisplay = "-" + (str.Replace(" - ", " - " + temp));
                                else
                                    StrDisplay += "<br/>- " + str;
                                count++;
                            }
                        }
                    }
                    else lttHistory_TP += "<b>- " + rv["TENTHAMPHAN"] + ((String.IsNullOrEmpty(rv["NGAYPHANCONGTP"] + "") || rv["NGAYPHANCONGTP"].ToString() == "01/01/0001") ? "" : (" (" + (rv["NGAYPHANCONGTP"]).ToString() + ")")) + "</b>";
                    lttHistory_TP += (string.IsNullOrEmpty(StrDisplay) ? "" : "<br/>") + "<i>" + StrDisplay + "</i>";
                    if (!String.IsNullOrEmpty(PhanCongTP))
                        lttTP.Text = lttHistory_TP;

                    Decimal check_tp = Convert.ToDecimal(rv["CHECK_VUAN"]);

                    if (check_tp > 0)
                    {
                        e.Item.ToolTip = "Vụ án đang giải quyết, để nghị sang phần <4.Thay đổi Thẩm phán giải quyết> để thay đổi Thẩm phán!";
                        chk.Visible = false;
                    }
                }
            }
            catch (Exception ex) { }
        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            dgList.PageSize = Convert.ToInt32(ddlPageCount2.SelectedValue);
            Load_Data();
        }
        #endregion

        protected void dgList_ItemCreated(object sender, DataGridItemEventArgs e)
        {
            string vLoai = Request["type"] + "";
            if (vLoai == "VUANKN")
            {
                // Chỉ áp dụng cho những loại dòng thực tế
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Header || e.Item.ItemType == ListItemType.Footer)
                {
                    e.Item.Cells[10].Visible = false;
                    e.Item.Cells[11].Visible = false;
                }
            }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lblThongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_PCTP_CHITIET oCT = dt.GDTTT_PCTP_CHITIET.Where(x => x.ID == ID).FirstOrDefault();
                    GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == oCT.DONID).FirstOrDefault();
                    if (oDon.CD_TRANGTHAI == 0 || oDon.CD_TRANGTHAI == 3)
                    {
                        oDon.THAMPHANID = 0;
                        dt.GDTTT_PCTP_CHITIET.Remove(oCT);
                        dt.SaveChanges();
                        Load_Data();
                    }
                    else
                    {
                        lblThongbao.Text = "Đơn đã được chuyển đi, không được phép xóa!";
                    }
                    break;
            }
        }

        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            ddlThamphan.SelectedIndex = ddlToaXetXu.SelectedIndex = 0;
            txtNguoigui.Text = txtSoQDBA.Text = txtThuly_Ngay.Text = txtThuly_So.Text = "";
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox curr_chk = (CheckBox)sender;
            SetPhanCongTP(curr_chk, dgList);

        }
        void SetPhanCongTP(CheckBox curr_chk, DataGrid grid)
        {
            string vLoai = Request["type"] + "";
            foreach (DataGridItem Item in grid.Items)
            {
                DropDownList dropThamPhan = (DropDownList)Item.FindControl("ddlThamPhan");
                TextBox txtNgayPhanCongTP = (TextBox)Item.FindControl("txtNgayPhanCongTP");
                TextBox txtLyDo = (TextBox)Item.FindControl("txtGhichu");
                TextBox txtSoTT = (TextBox)Item.FindControl("txtSoTT");
                TextBox txtNgayToTrinh = (TextBox)Item.FindControl("txtNgayToTrinh");

                Literal lttTP = (Literal)Item.FindControl("lttTP");

                CheckBox chk = (CheckBox)Item.FindControl("chkChon");

                HiddenField NGAYPHANCONGTP = (HiddenField)Item.FindControl("NGAYPHANCONGTP");
                HiddenField hddTPID = (HiddenField)Item.FindControl("hddTPID");

                AjaxControlToolkit.CalendarExtender CE_PCTP = (AjaxControlToolkit.CalendarExtender)Item.FindControl("CE_PCTP");

                if (chk.Checked)
                {
                    dropThamPhan.Visible = true;
                    lttTP.Visible = false;

                    if (vLoai == "VUANKN")
                        txtSoTT.Enabled = txtNgayToTrinh.Enabled = false;
                    else
                        txtSoTT.Enabled = txtNgayToTrinh.Enabled = true;

                    txtNgayPhanCongTP.Enabled = true; txtLyDo.Enabled = true;

                    if (NGAYPHANCONGTP != null)
                    {
                        if (!string.IsNullOrEmpty(NGAYPHANCONGTP.Value.Trim()))
                        {
                            CE_PCTP.StartDate = DateTime.ParseExact(NGAYPHANCONGTP.Value, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                            txtNgayPhanCongTP.Text = NGAYPHANCONGTP.Value;
                        }
                    }
                    if (!string.IsNullOrEmpty(hddTPID.Value.Trim()))
                        try { dropThamPhan.SelectedValue = hddTPID.Value; } catch { }
                }
                else
                {
                    lttTP.Visible = true;
                    dropThamPhan.Visible = false;

                    if (vLoai == "VUANKN")
                        txtSoTT.Enabled = txtNgayToTrinh.Enabled = false;
                    else
                        txtSoTT.Enabled = txtNgayToTrinh.Enabled = true;

                    txtNgayPhanCongTP.Enabled = false; txtLyDo.Enabled = true;
                }
            }
        }

        protected void dropThamPhan_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal temp_id = 0;
            DataGridItemCollection lstG = dgList.Items;
            foreach (DataGridItem Item in lstG)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    TextBox txtLyDo = (TextBox)Item.FindControl("txtGhichu");
                    TextBox txtSoTT = (TextBox)Item.FindControl("txtSoTT");
                    TextBox txtNgayToTrinh = (TextBox)Item.FindControl("txtNgayToTrinh");
                    TextBox txtNgayPhanCongTP = (TextBox)Item.FindControl("txtNgayPhanCongTP");
                    DropDownList ddlThamphan = (DropDownList)Item.FindControl("ddlThamphan");
                    temp_id = Convert.ToDecimal(ddlThamphan.SelectedValue);
                    if (temp_id > 0)
                    {
                        txtLyDo.Text = txtNgayPhanCongTP.Text = txtSoTT.Text = txtNgayToTrinh.Text = "";
                    }
                }
            }
        }

        void UpdateHistory_PCTP_DON(Decimal KQCT_ID, String Lydo, Decimal giaidoan, Decimal Thamphan_new, DateTime Denngay, String SoTT, DateTime NgayTT, Decimal nguoisua)
        {
            DateTime? date_temp = (DateTime?)null;
            Decimal vThamPhanID = 0;
            GDTTT_VUAN_PHANCONG_THAMPHAN obj = new GDTTT_VUAN_PHANCONG_THAMPHAN();
            GDTTT_VUAN_THAMPHAN_HISTORY_BL BLobj = new GDTTT_VUAN_THAMPHAN_HISTORY_BL();

            GDTTT_PCTP_CHITIET oKQCT = dt.GDTTT_PCTP_CHITIET.Where(x => x.ID == KQCT_ID).FirstOrDefault();
            if (oKQCT != null)
            {
                vThamPhanID = (string.IsNullOrEmpty(oKQCT.CANBOID + "")) ? 0 : (Decimal)oKQCT.CANBOID;
                //Lay ra ngay thực hiện Phân công TP 
                if (oKQCT.NGAYPHANCONGTP == null)
                {
                    GDTTT_PCTP_KETQUA oKQPC = dt.GDTTT_PCTP_KETQUA.Where(x => x.ID == oKQCT.KETQUAID).Single();
                    date_temp = oKQPC.NGAYPHANCONG;
                }//nếu không có thì lấy ngày tờ trình
                else
                    date_temp = oKQCT.NGAYPHANCONGTP;

                if (vThamPhanID > 0)
                {
                    obj = new GDTTT_VUAN_PHANCONG_THAMPHAN();
                    obj.DONID = Convert.ToDecimal(oKQCT.DONID);
                    obj.THAMPHAN_ID_OLD = vThamPhanID;
                    if (date_temp != null)
                        obj.TUNGAY = Convert.ToDateTime(date_temp);
                    obj.THAMPHAN_ID_NEW = Thamphan_new;
                    obj.DENNGAY = Denngay;
                    obj.LYDO = Lydo;
                    obj.GIAIDOAN = 1;
                    obj.SOTT = SoTT;
                    obj.NGAYTT = NgayTT;
                    obj.CANBOSUA_ID = nguoisua;
                    if (obj.THAMPHAN_ID_OLD > 0)
                    {
                        BLobj.GDTTT_VUAN_THAMPHAN_HISTORY_Insert_Update(obj);
                    }
                }
            }
        }

        void UpdateHistory_PCTP_DON_CHI_DINH(Decimal KQCT_ID, String Lydo, Decimal giaidoan, Decimal Thamphan_new, DateTime Denngay, String SoTT, DateTime NgayTT, Decimal nguoisua)
        {
            DateTime? date_temp = (DateTime?)null;
            Decimal vThamPhanID = 0;
            GDTTT_VUAN_PHANCONG_THAMPHAN obj = new GDTTT_VUAN_PHANCONG_THAMPHAN();
            GDTTT_VUAN_THAMPHAN_HISTORY_BL BLobj = new GDTTT_VUAN_THAMPHAN_HISTORY_BL();

            GDTTT_PCTP_CHITIET_CHIDINH oKQCT = dt.GDTTT_PCTP_CHITIET_CHIDINH.Where(x => x.ID == KQCT_ID).FirstOrDefault();
            if (oKQCT != null)
            {
                vThamPhanID = (string.IsNullOrEmpty(oKQCT.CANBOID + "")) ? 0 : (Decimal)oKQCT.CANBOID;
                //Lay ra ngay thực hiện Phân công TP 
                if (oKQCT.NGAYPHANCONGTP == null)
                {
                    GDTTT_PCTP_KETQUA_CHIDINH oKQPC = dt.GDTTT_PCTP_KETQUA_CHIDINH.Where(x => x.ID == oKQCT.KETQUAID).Single();
                    date_temp = oKQPC.NGAYPHANCONG;
                }//nếu không có thì lấy ngày tờ trình
                else
                    date_temp = oKQCT.NGAYPHANCONGTP;

                if (vThamPhanID > 0)
                {
                    obj = new GDTTT_VUAN_PHANCONG_THAMPHAN();
                    obj.DONID = Convert.ToDecimal(oKQCT.DONID);
                    obj.THAMPHAN_ID_OLD = vThamPhanID;
                    if (date_temp != null)
                        obj.TUNGAY = Convert.ToDateTime(date_temp);
                    obj.THAMPHAN_ID_NEW = Thamphan_new;
                    obj.DENNGAY = Denngay;
                    obj.LYDO = Lydo;
                    obj.GIAIDOAN = 1;
                    obj.SOTT = SoTT;
                    obj.NGAYTT = NgayTT;
                    obj.CANBOSUA_ID = nguoisua;
                    if (obj.THAMPHAN_ID_OLD > 0)
                    {
                        BLobj.GDTTT_VUAN_THAMPHAN_HISTORY_Insert_Update(obj); //check lại chỗ update history
                    }
                }
            }
        }
    }
}