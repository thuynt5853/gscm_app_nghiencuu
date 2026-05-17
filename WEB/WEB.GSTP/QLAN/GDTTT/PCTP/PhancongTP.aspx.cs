using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using WEB.GSTP.QLAN.GDTTT.In;

using System.Web.UI;
using System.Web;
using System.Windows;

namespace WEB.GSTP.QLAN.GDTTT.PCTP
{
    public partial class PhancongTP : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
                    decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
                    txtToaan.Text = oTA.MA_TEN;
                    txtNgayphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    txtTuNgay.Text = DateTime.Now.AddDays(-7).ToString("dd/MM/yyyy", cul);
                    txtDenNgay.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    LoadCanbo(ENUM_CHUCDANH.CHUCDANH_THAMPHAN);

                    QT_NGUOIDUNG_BL oNDBL = new QT_NGUOIDUNG_BL();
                    chkNguoinhap.DataSource = oNDBL.QT_NGUOIDUNG_GETBYGDTTT(ToaAnID, 0, 0);
                    chkNguoinhap.DataTextField = "USERNAME";
                    chkNguoinhap.DataValueField = "USERNAME";
                    chkNguoinhap.DataBind();

                    chkLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIVUVIEC.AN_HINHSU));
                    chkLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIVUVIEC.AN_DANSU));
                    chkLoaiAn.Items.Add(new ListItem("KDTM", ENUM_LOAIVUVIEC.AN_KINHDOANH_THUONGMAI));
                    chkLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIVUVIEC.AN_PHASAN));
                    chkLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIVUVIEC.AN_HANHCHINH));
                    chkLoaiAn.Items.Add(new ListItem("HN & GĐ", ENUM_LOAIVUVIEC.AN_HONNHAN_GIADINH));
                    chkLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIVUVIEC.AN_LAODONG));
                    //TPB3
                    if (rdbTPb.SelectedValue == "0")
                    {
                        ddlHinhthuc.Items.Insert(2, new ListItem("Kháng nghị CATANDTC(TP Bậc 3 GQ)", "2"));
                    }
                    else
                    {
                        try { ddlHinhthuc.Items.RemoveAt(2); } catch (Exception ex) { }
                    }
                    //End

                }
                catch (Exception exx) { lblThongbao.Text = exx.Message; }
            }
        }

        //TPB3
        protected void rdbTPb_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            if (rdbTPb.SelectedValue == "0")
            {
                ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "0", 0);
                ddlHinhthuc.Items.Insert(2, new ListItem("Kháng nghị CATANDTC(TP Bậc 3 GQ)", "2"));
            }
            else
            {
                ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "1", 0);
                try { ddlHinhthuc.Items.RemoveAt(2); } catch (Exception ex) { }
            }
            ddlThamphan.DataTextField = "hotenngaysinh";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            Load_Data();
        }

        protected void rdbPc_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbPc.SelectedItem.Value.Equals("0"))
            {
                lblThongbao.Text = "";
                cmdUpdate.Text = "2. Phân công ngẫu nhiên";
                dgList.Visible = true;
                if (dgList.Items.Count <= 0)
                {
                    lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
                }
                dgListC.Visible = false;
                chkNguoinhap.Enabled = false;
                chkLoaiAn.Enabled = false;
                lblThamphan.Visible = false;
                ddlThamphan.Visible = false;
                lblSothuly.Visible = false;
                lblNgayThuLy.Visible = false;
                lblSoBAQD.Visible = false;
                txtSoThuLy.Visible = false;
                txtNgayThuLy.Visible = false;
                txtSoBAQD.Visible = false;
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                QT_NGUOIDUNG_BL oNDBL = new QT_NGUOIDUNG_BL();
                chkNguoinhap.DataSource = oNDBL.QT_NGUOIDUNG_GETBYGDTTT(ToaAnID, 0, 0);
                chkNguoinhap.DataTextField = "USERNAME";
                chkNguoinhap.DataValueField = "USERNAME";
                chkNguoinhap.DataBind();
            }
            else
            {
                lblThongbao.Text = "";
                cmdUpdate.Text = "2. Phân công chỉ định";
                dgList.Visible = false;
                dgListC.Visible = true;
                if (dgListC.Items.Count <= 0)
                {
                    lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
                }
                chkNguoinhap.Enabled = true;
                chkLoaiAn.Enabled = true;
                txtTuNgay.Text = DateTime.Now.AddDays(-7).ToString("dd/MM/yyyy", cul);
                lblThamphan.Visible = true;
                ddlThamphan.Visible = true;
                lblSothuly.Visible = true;
                lblNgayThuLy.Visible = true;
                lblSoBAQD.Visible = true;
                txtSoThuLy.Visible = true;
                txtNgayThuLy.Visible = true;
                txtSoBAQD.Visible = true;
                decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                if (rdbTPb.SelectedValue == "0")
                {
                    ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "0", 0);
                }
                else
                {
                    ddlThamphan.DataSource = oBL.THAMPHAN_GETBY_NC(ToaAnID, "1", 0);
                }
                ddlThamphan.DataTextField = "Hotenngaysinh";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
            }
        }
        //End

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

        private DataTable getDS()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            DateTime? TuNgay = txtTuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault),
                DenNgay = txtDenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

            decimal vNoichuyen = 0;
            decimal vTrangthai = 0;
            decimal vIsThuLy = 1;
            string strNguoiNhap = "";
            foreach (ListItem i in chkNguoinhap.Items)
            {
                if (i.Selected)
                {
                    if (strNguoiNhap == "")
                        strNguoiNhap = i.Value;
                    else
                        strNguoiNhap = strNguoiNhap + "," + i.Value;
                }
            }
            if (strNguoiNhap != "") strNguoiNhap = "," + strNguoiNhap + ",";
            string strLoaiAn = "";
            foreach (ListItem i in chkLoaiAn.Items)
            {
                if (i.Selected)
                {
                    string strLA = Convert.ToDecimal(i.Value).ToString();
                    if (strLoaiAn == "")
                        strLoaiAn = strLA;
                    else
                        strLoaiAn = strLoaiAn + "," + strLA;
                }
            }
            if (strLoaiAn != "") strLoaiAn = "," + strLoaiAn + ",";
            if (DenNgay != null) DenNgay = ((DateTime)DenNgay).AddHours(23);

            //DataTable oDT = oBL.GDTTT_DON_GETPCTP(ToaAnID,  TuNgay, DenNgay, vNoichuyen,
            //       vTrangthai,  vIsThuLy, strNguoiNhap, strLoaiAn);
            decimal isChiDinh = Convert.ToDecimal(rdbPc.SelectedItem.Value);
            string vHinhTHuc = ddlHinhthuc.SelectedValue;
            if (vHinhTHuc == "2") //lấy vụ án Kháng nghị CATANDTC(TP Bậc 3 GQ)
            {
                DataTable oDT = oBL.GDTTT_VUAN_KHANGNGHI_GETCPC(ToaAnID, TuNgay, DenNgay, vNoichuyen,
                vTrangthai, vIsThuLy, strNguoiNhap, strLoaiAn, isChiDinh);
                return oDT;
            }
            else
            {
                if (rdbTPb.SelectedItem.Value.Equals("0"))
                {
                    DateTime? ngayTL = string.IsNullOrEmpty(txtNgayThuLy.Text) ? (DateTime?)null : DateTime.Parse(txtNgayThuLy.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    DataTable oDT = oBL.GDTTT_DON_GETPCTP(ToaAnID, TuNgay, DenNgay, vNoichuyen, vTrangthai, vIsThuLy, strNguoiNhap, strLoaiAn, isChiDinh, ngayTL, txtSoThuLy.Text, txtSoBAQD.Text);
                    return oDT;
                }
                else
                {
                    DateTime? ngayTL = string.IsNullOrEmpty(txtNgayThuLy.Text) ? (DateTime?)null : DateTime.Parse(txtNgayThuLy.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    DataTable oDT = oBL.GDTTT_DON_GETPTP_TPB3(ToaAnID, TuNgay, DenNgay, vNoichuyen, vTrangthai, vIsThuLy, strNguoiNhap, strLoaiAn, isChiDinh, ngayTL, txtSoThuLy.Text, txtSoBAQD.Text);
                    return oDT;
                }
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

            if (rdbPc.SelectedItem.Value.Equals("0"))
            {
                //Phân công ngẫu nhiên
                dgList.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgList.DataSource = oDT;
                dgList.DataBind();
            }
            else
            {
                //Phân công chỉ định
                dgListC.PageSize = Convert.ToInt32(ddlPageCount.SelectedValue);
                dgListC.DataSource = oDT;
                dgListC.DataBind();
            }
        }

        protected void LoadCanbo(string strMaChucdanh)
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            rptCanbo.DataSource = oBL.CANBO_GETBYDONVI_XX(ToaAnID, strMaChucdanh);
            rptCanbo.DataBind();
        }

        protected void cmdTraCuu_Click(object sender, EventArgs e)
        {
            Load_Data();
            hddKetquaID.Value = "";
            cmdPrint.Visible = false;
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            if (Cls_Comon.IsValidDate(txtTuNgay.Text) == false)
            {
                lblThongbao.Text = "Từ ngày chưa nhập hoặc không hợp lệ !";
                return;
            }
            if (Cls_Comon.IsValidDate(txtDenNgay.Text) == false)
            {
                lblThongbao.Text = "Đến ngày chưa nhập hoặc không hợp lệ !";
                return;
            }

            DateTime dTuNgay = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime dDenNgay = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dTuNgay > dDenNgay)
            {
                lblThongbao.Text = "Ngày bắt đầu không được lớn hơn ngày bắt kết thúc !";
                return;
            }

            //TPB3
            if (rdbPc.SelectedItem.Value.Equals("0"))
            {
                if (dgList.Items.Count == 0)
                {
                    lblThongbao.Text = "Không có đơn thụ lý mới!";
                    return;
                }
            }
            else
            {
                if (dgListC.Items.Count == 0)
                {
                    lblThongbao.Text = "Không có đơn thụ lý mới!";
                    return;
                }
            }

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oPCBL = new GDTTT_DON_BL();
            dTuNgay = DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dDenNgay = DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dDenNgay = dDenNgay.AddHours(23);
            string strNguoiNhap = "";
            foreach (ListItem i in chkNguoinhap.Items)
            {
                if (i.Selected)
                {
                    if (strNguoiNhap == "")
                        strNguoiNhap = i.Value;
                    else
                        strNguoiNhap = strNguoiNhap + "," + i.Value;
                }
            }
            if (strNguoiNhap != "") strNguoiNhap = "," + strNguoiNhap + ",";
            string strLoaiAn = "";
            foreach (ListItem i in chkLoaiAn.Items)
            {
                if (i.Selected)
                {
                    string strLA = Convert.ToDecimal(i.Value).ToString();
                    if (strLoaiAn == "")
                        strLoaiAn = strLA;
                    else
                        strLoaiAn = strLoaiAn + "," + strLA;
                }
            }
            if (strLoaiAn != "") strLoaiAn = "," + strLoaiAn + ",";
            //TPB3

            decimal IDKETQUA = 0;
            //phân công ngẫu nhiên
            if (rdbPc.SelectedItem.Value.Equals("0"))
            {
                //phân công cho TPTC
                if (rdbTPb.SelectedItem.Value.Equals("0"))
                {
                    if (ddlHinhthuc.SelectedValue == "2") //phân công ngẫu nhiên vụ án Kháng nghị cho TPTC
                        IDKETQUA = oPCBL.PHANCONGNGAUNHIEN_VAKN(ToaAnID, dTuNgay, dDenNgay, strNguoiNhap, strLoaiAn, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    else
                        IDKETQUA = oPCBL.PHANCONGNGAUNHIEN(ToaAnID, dTuNgay, dDenNgay, strNguoiNhap, strLoaiAn, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                }
                else
                { 
                    //phân công cho TPB3
                    IDKETQUA = oPCBL.PHANCONGNGAUNHIEN_TPB3(ToaAnID, dTuNgay, dDenNgay, strNguoiNhap, strLoaiAn, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                }
            }
            else //phân công chỉ định
            {
                List<decimal> lstVuANID = new List<decimal>();
                string checkds = "";
                var rows = dgListC.Items;
                int count = dgListC.Items.Count;
                for (int i = 0; i < count; i++)
                {
                    bool isChecked = ((CheckBox)rows[i].FindControl("chkSelect")).Checked;
                    if (isChecked)
                    {
                        string checkds1 = ((TextBox)rows[i].FindControl("txtCheck")).Text;
                        if (checkds == "")
                            checkds = checkds1;
                        else
                            checkds = checkds + "," + checkds1;

                        decimal vVuAnID;
                        if (decimal.TryParse(checkds1, out vVuAnID))
                            lstVuANID.Add(vVuAnID);
                    }
                }
                if (checkds != "") checkds = "," + checkds + ",";
                if (checkds == "")
                {
                    lblThongbao.Text = "Bạn chưa chọn danh sách để phân công  !";
                    return;
                }

                if (ddlHinhthuc.SelectedValue == "2") //phân công chỉ định vụ án Kháng nghị cho TPTC
                {
                    IDKETQUA = oPCBL.INSERT_PHANCONG_CHIDINH_VAKN_TPTC(ToaAnID, dTuNgay, dDenNgay, strNguoiNhap, strLoaiAn, Session[ENUM_SESSION.SESSION_USERNAME] + "", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]), rdbTPb.SelectedValue, Convert.ToDecimal(ddlThamphan.SelectedValue), lstVuANID);
                }
                else
                {
                    IDKETQUA = oPCBL.PHANCONGCHIDINH(ToaAnID, dTuNgay, dDenNgay, strNguoiNhap, strLoaiAn, Session[ENUM_SESSION.SESSION_USERNAME] + "", Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]), checkds, rdbTPb.SelectedValue, Convert.ToDecimal(ddlThamphan.SelectedValue));
                }
            }
            //END 
            //decimal IDKETQUA = oPCBL.PHANCONGNGAUNHIEN(ToaAnID, dTuNgay, dDenNgay, strNguoiNhap, strLoaiAn, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (IDKETQUA > 0)
            {
                cmdPrint.Visible = true;
                hddKetquaID.Value = IDKETQUA.ToString();

                //TPB3
                if (rdbPc.SelectedItem.Value.Equals("0"))
                {
                    lblThongbao.Text = "Hoàn thành phân công ngẫu nhiên !";
                }
                else
                {
                    lblThongbao.Text = "Hoàn thành phân công chỉ định !";
                }

                if (rdbPc.SelectedItem.Value.Equals("0"))
                {
                    string vHinhTHuc = ddlHinhthuc.SelectedValue;
                    if (vHinhTHuc == "2") //lấy vụ án Kháng nghị CATANDTC(TP Bậc 3 GQ)
                        dgList.DataSource = oPCBL.GET_THEOKETQUAID_PHANCONGNGAUNHIEN_VAKN(ToaAnID, IDKETQUA, 0, "", "", "", "", "", 0);
                    else
                        dgList.DataSource = oPCBL.DON_GETTHEOKETQUAID(ToaAnID, IDKETQUA, 0, "", "", "", "", "", 0); //Lay ket qua phân công ngẫu nhiên

                    dgList.DataBind();
                    dgList.Visible = true;
                    dgListC.Visible = false;
                }
                else
                {
                    string vHinhTHuc = ddlHinhthuc.SelectedValue;
                    if (vHinhTHuc == "2") //lấy vụ án Kháng nghị CATANDTC(TP Bậc 3 GQ)
                    {
                        DateTime? TuNgay = txtTuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                        DateTime? DenNgay = txtDenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);

                        DataTable oDT = oPCBL.VAKN_GET_THEO_KETQUA_CHIDINHID(ToaAnID, TuNgay, DenNgay, 0,
                        1, 1, strNguoiNhap, strLoaiAn, 0, IDKETQUA);

                        //Phân công chỉ định vụ án kháng nghị
                        dgList.DataSource = oDT;
                    }
                    else
                    {
                        //lay kết quả phân công chỉ định đơn
                        dgList.DataSource = oPCBL.DON_GETTHEOKETQUAID_CHIDINH(ToaAnID, IDKETQUA, 0, "", "", "", "", "", 0, rdbTPb.SelectedValue);
                    }
                    dgList.DataBind();
                    dgList.Visible = true;
                    dgListC.Visible = false;
                }

                rdbPc.Enabled = false;
                cmdUpdate.Enabled = false;
            }
            else
                lblThongbao.Text = "Lỗi trong quá trình phân công !";
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
            Load_Data();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }
        #endregion

        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            GDTTT_DON_BL oPCBL = new GDTTT_DON_BL();
            decimal KQ_id = Convert.ToDecimal(hddKetquaID.Value);
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            Session["GDTTT_MABM"] = "PHANCONG_KETQUA";
            #region "Thông tin kết quả"
            DTGDTTT objds = new DTGDTTT();
            GDTTT_PCTP_KETQUA k = dt.GDTTT_PCTP_KETQUA.Where(x => x.ID == KQ_id).FirstOrDefault();
            DTGDTTT.DT_PHANCONG_KETQUARow rk = objds.DT_PHANCONG_KETQUA.NewDT_PHANCONG_KETQUARow();
            rk.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            rk.TUNGAY = ((DateTime)k.TUNGAY).ToString("dd/MM/yyyy");
            rk.DENNGAY = ((DateTime)k.DENNGAY).ToString("dd/MM/yyyy");
            rk.NGAYTHUCHIEN = ((DateTime)k.NGAYPHANCONG).ToString("dd/MM/yyyy HH:MM");
            DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == k.NGUOITHUCHIENID).FirstOrDefault();
            if (oCB != null) rk.NGUOITHUCHIEN = oCB.HOTEN;
            objds.DT_PHANCONG_KETQUA.AddDT_PHANCONG_KETQUARow(rk);
            objds.AcceptChanges();
            #endregion
            //DANH SÁCH đơn
            int i = 0;
            DataTable oDT = oPCBL.DON_GETTHEOKETQUAID(ToaAnID, KQ_id, 0, "", "", "", "", "", 0);
            foreach (DataRow obj in oDT.Rows)
            {
                i += 1;
                DTGDTTT.DT_PHANCONG_CHITIETRow rds = objds.DT_PHANCONG_CHITIET.NewDT_PHANCONG_CHITIETRow();
                rds.NGUOIGUI = obj["NGUOIGUI_HOTEN"] + "";
                if (obj["NGUOIGUI_HUYENID"] != null)
                {
                    decimal HuyenID = Convert.ToDecimal(obj["NGUOIGUI_HUYENID"]);
                    DM_HANHCHINH oTinh = dt.DM_HANHCHINH.Where(x => x.ID == HuyenID).FirstOrDefault();
                    rds.DIAPHUONG = obj["Diachigui"] + ", " + oTinh.MA_TEN;
                }
                else
                    rds.DIAPHUONG = obj["Diachigui"] + "";
                rds.TT = i.ToString();
                rds.NGAYNHAN = Convert.ToDateTime(obj["NGAYNHANDON"]).ToString("dd/MM/yyyy");
                rds.TENTHAMPHAN = obj["TENTHAMPHAN"] + "";
                rds.TENTHAMPHANSUA = obj["TENTHAMPHANSUA"] + "";
                objds.DT_PHANCONG_CHITIET.AddDT_PHANCONG_CHITIETRow(rds);
                objds.AcceptChanges();
            }
            Session["NOIBO_DATASET"] = objds;

            string StrMsg = "PopupReport('/QLAN/GDTTT/In/ViewReport.aspx','Tờ trình',800,800);";
            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrMsg, true);
        }

        protected void dropHinhthuc_SelectedIndexChanged(object sender, EventArgs e)
        {
            Load_Data();
        }
    }
}