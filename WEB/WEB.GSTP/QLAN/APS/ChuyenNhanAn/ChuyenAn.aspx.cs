using BL.GSTP;
using BL.GSTP.APS;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.APS;
using BL.GSTP.QLHS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.APS.ChuyenNhanAn
{
    public partial class ChuyenAn : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadGrid();
                    Cls_Comon.SetButton(cmdNhanan, false);
                    Cls_Comon.SetButton(cmdNhandon, false);
                    Cls_Comon.SetButton(cmdHuyChuyen, false);
                    Cls_Comon.SetButton(cmdHuyChuyendon, false);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadGrid()
        {
            lbthongbao.Text = "";
            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal vToaNhanID = 0;
            vToaNhanID = hddToaAnNhan.Value == "" ? 0 : Convert.ToDecimal(hddToaAnNhan.Value);
            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            TongHop_BL oBL = new TongHop_BL();
            string current_id = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.PS_CHUYENAN(vDonViID, txtTenToa.Text.Trim(), txtMaVuViec.Text.Trim(), txtTenVuViec.Text.Trim(), txtSoquyetdinh.Text.Trim(), txtSobanan.Text.Trim(), dFrom, dTo, txtTenduongsu.Text.Trim(), Convert.ToDecimal(rdbTrangthai.SelectedValue), Convert.ToDecimal(rdbLoai.SelectedValue));

            #region "Xác định số lượng trang"
            int Total = Convert.ToInt32(oDT.Rows.Count);
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            #endregion
            dgList.DataSource = oDT;
            dgList.DataBind();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdNhanan_Click(object sender, EventArgs e)
        {


            lbthongbao.Text = "";
            List<CUS_CHUYENAN_INPUT> data = new List<CUS_CHUYENAN_INPUT>();
            //fill data
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                HiddenField hddLydo = (HiddenField)Item.FindControl("hddLydo");
                HiddenField hddTHGiaoNhan = (HiddenField)Item.FindControl("hddTHGiaoNhan");
                if (chkChon.Checked)
                {
                    CUS_CHUYENAN_INPUT input = new CUS_CHUYENAN_INPUT();
                    input.VuViecID = Item.Cells[0].Text;
                    input.MaVuVien = Item.Cells[1].Text;
                    input.TenVuVien = Item.Cells[4].Text;
                    input.NgayGiao = DateTime.Now.ToString("dd/MM/yyyy");
                    input.ToaGiao = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    input.TruongHopGiaoNhan = hddTHGiaoNhan.Value;
                    input.LyDoId = hddLydo.Value;
                    input.isEnableToaAnTen = true;
                    //hddVuViecID.Value = Item.Cells[0].Text;
                    //txtN_Mavuviec.Text = Item.Cells[1].Text;
                    //txtN_Tenvuviec.Text = Item.Cells[4].Text;
                    //txtN_Ngaygiao.Text = DateTime.Now.ToString("dd/MM/yyyy");
                    //txtN_Toagiao.Text = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                    //txtN_THGN.Text = hddTHGiaoNhan.Value;
                    //hddTHGN.Value = hddLydo.Value;
                    decimal IDVUAN = Convert.ToDecimal(input.VuViecID);
                    if (rdbLoai.SelectedValue == "0")
                    {
                        APS_DON_XULY donXuLy = dt.APS_DON_XULY.Where(x => x.DONID == IDVUAN).FirstOrDefault();
                        decimal idToaNhan = donXuLy.CDTN_TOAANID ?? 0;
                        DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == idToaNhan).FirstOrDefault();
                        if (toaAn != null)
                        {
                            input.ToaAn_ID = toaAn.ID.ToString();
                            input.ToaAn_Ten = toaAn.MA_TEN;
                        }
                        input.isEnableToaAnTen = false;
                    }
                    else
                    {
                        if (hddLydo.Value != "01" && hddLydo.Value != "05")
                        {
                            DM_TOAAN toaAn = null;
                            decimal ToaAnSoThamID = 0, ToaAnCapChaID = 0;

                            ToaAnSoThamID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                            toaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnSoThamID).FirstOrDefault();
                            if (toaAn != null)
                            {
                                ToaAnCapChaID = toaAn.CAPCHAID == null ? 0 : (decimal)toaAn.CAPCHAID;
                            }

                            if (ToaAnCapChaID == 0)
                            {

                                toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == ToaAnSoThamID).FirstOrDefault<DM_TOAAN>();

                            }
                            else
                            {
                                toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == ToaAnCapChaID).FirstOrDefault<DM_TOAAN>();
                            }
                            if (toaAn != null)
                            {
                                input.ToaAn_ID = toaAn.ID.ToString();
                                input.ToaAn_Ten = toaAn.MA_TEN;
                            }
                            input.isEnableToaAnTen = false;
                        }
                        else if (hddLydo.Value == "05")
                        {
                            //decimal IDVUAN = Convert.ToDecimal(input.VuViecID);
                            APS_DON oDon = dt.APS_DON.Where(x => x.ID == IDVUAN).FirstOrDefault();
                            if (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                            {
                                APS_CHUYEN_NHAN_AN_BL APS_CHUYEN_NHAN_AN_BL = new APS_CHUYEN_NHAN_AN_BL();
                                decimal donIdOld = APS_CHUYEN_NHAN_AN_BL.getDonIdOld(oDon.ID);
                                APS_DON oDonOld = dt.APS_DON.Where(x => x.ID == donIdOld).FirstOrDefault();
                                DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == oDonOld.TOAANID).FirstOrDefault();
                                if (toaAn != null)
                                {
                                    input.ToaAn_ID = toaAn.ID.ToString();
                                    input.ToaAn_Ten = toaAn.MA_TEN;
                                }
                            }
                            else
                            {
                                DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                                if (toaAn != null)
                                {
                                    input.ToaAn_ID = toaAn.ID.ToString();
                                    input.ToaAn_Ten = toaAn.MA_TEN;
                                }
                            }
                            input.isEnableToaAnTen = false;
                        }
                        else
                        {
                            input.isEnableToaAnTen = true;
                        }
                    }
                    data.Add(input);
                }


            }

            rptCapNhat.DataSource = data;
            rptCapNhat.DataBind();
            //foreach (DataGridItem Item in dgList.Items)
            //{
            //    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
            //    HiddenField hddLydo = (HiddenField)Item.FindControl("hddLydo");
            //    HiddenField hddTHGiaoNhan = (HiddenField)Item.FindControl("hddTHGiaoNhan");
            //    if (chkChon.Checked)
            //    {
            //        hddVuViecID.Value = Item.Cells[0].Text;
            //        txtN_Mavuviec.Text = Item.Cells[1].Text;
            //        txtN_Tenvuviec.Text = Item.Cells[4].Text;
            //        txtN_Ngaygiao.Text = DateTime.Now.ToString("dd/MM/yyyy");
            //        txtN_Toagiao.Text = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
            //        txtN_THGN.Text = hddTHGiaoNhan.Value;
            //        hddTHGN.Value = hddLydo.Value;
            //        if (hddTHGN.Value != "01" && hddTHGN.Value != "05")
            //        {
            //            DM_TOAAN toaAn = null;
            //            decimal ToaAnSoThamID = 0, ToaAnCapChaID = 0;

            //            ToaAnSoThamID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            //            toaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnSoThamID).FirstOrDefault();
            //            if (toaAn != null)
            //            {
            //                ToaAnCapChaID = toaAn.CAPCHAID == null ? 0 : (decimal)toaAn.CAPCHAID;
            //            }

            //            if (ToaAnCapChaID == 0)
            //            {
            //                toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == ToaAnSoThamID).FirstOrDefault<DM_TOAAN>();
            //            }
            //            else
            //            {
            //                toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == ToaAnCapChaID).FirstOrDefault<DM_TOAAN>();
            //            }
            //            if (toaAn != null)
            //            {
            //                hddTN_ID.Value = toaAn.ID.ToString();
            //                txtTN_Ten.Text = toaAn.MA_TEN;
            //            }
            //            txtTN_Ten.Enabled = false;
            //        }
            //        else if (hddTHGN.Value == "05")
            //        {
            //            decimal IDVUAN = Convert.ToDecimal(hddVuViecID.Value);
            //            APS_DON oDon = dt.APS_DON.Where(x => x.ID == IDVUAN).FirstOrDefault();
            //            DM_TOAAN toaAn = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
            //            if (toaAn != null)
            //            {
            //                hddTN_ID.Value = toaAn.ID.ToString();
            //                txtTN_Ten.Text = toaAn.MA_TEN;
            //            }
            //            txtTN_Ten.Enabled = false;
            //        }
            //        else
            //        {
            //            txtTN_Ten.Enabled = true;
            //        }
            //    }

            //}
            pnDanhsach.Visible = false;
            pnCapnhat.Visible = true;
        }
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            Cls_Comon.SetButton(cmdNhanan, false);
            Cls_Comon.SetButton(cmdNhandon, false);
            Cls_Comon.SetButton(cmdHuyChuyen, false);
            Cls_Comon.SetButton(cmdHuyChuyendon, false);
            if (rdbTrangthai.SelectedValue == "1")
            {
                Cls_Comon.SetButton(cmdNhanan, false);
                Cls_Comon.SetButton(cmdNhandon, false);
                Cls_Comon.SetButton(cmdHuyChuyen, true);
                Cls_Comon.SetButton(cmdHuyChuyendon, true);
            }
            else
            {
                Cls_Comon.SetButton(cmdNhanan, true);
                Cls_Comon.SetButton(cmdNhandon, true);
                Cls_Comon.SetButton(cmdHuyChuyen, false);
                Cls_Comon.SetButton(cmdHuyChuyendon, false);
            }
            //CheckBox chkXem = (CheckBox)sender;
            //foreach (DataGridItem Item in dgList.Items)
            //{
            //    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
            //    if (chkXem.Checked)
            //    {
            //        if (chkXem.ToolTip != chkChon.ToolTip) chkChon.Checked = false;
            //    }
            //}
        }
        protected void cmdLuu_Click(object sender, EventArgs e)
        {

            foreach (RepeaterItem item in rptCapNhat.Items)
            {
                DropDownList txtTN_Ten = (DropDownList)item.FindControl("txtTN_Ten");
                if (txtTN_Ten.SelectedValue == "" || txtTN_Ten.SelectedValue == "0")
                {
                    lbthongbaoNA.Text = "Bạn chưa chọn tòa án cần chuyển !";
                    txtTN_Ten.Focus();
                    return;
                }
            }
            foreach (RepeaterItem item in rptCapNhat.Items)
            {
                //HiddenField hddTN_ID = (HiddenField)item.FindControl("hddTN_ID");
                HiddenField hddVuViecID = (HiddenField)item.FindControl("hddVuViecID");
                HiddenField hddTHGN = (HiddenField)item.FindControl("hddTHGN");
                //Label lbthongbaoNA = (Label)item.FindControl("lbthongbaoNA");
                DropDownList txtTN_Ten = (DropDownList)item.FindControl("txtTN_Ten");
                TextBox txtN_Ngaygiao = (TextBox)item.FindControl("txtN_Ngaygiao");
                TextBox txtTN_ghichu = (TextBox)item.FindControl("txtTN_ghichu");
                try
                {



                    if (txtTN_Ten.SelectedValue == "" || txtTN_Ten.SelectedValue == "0")
                    {
                        lbthongbaoNA.Text = "Bạn chưa chọn tòa án cần chuyển !";
                        txtTN_Ten.Focus();
                        return;
                    }
                    decimal DONID = Convert.ToDecimal(hddVuViecID.Value);
                    APS_CHUYEN_NHAN_AN oND = new APS_CHUYEN_NHAN_AN();
                    oND.VUANID = DONID;
                    oND.TOACHUYENID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    oND.TOANHANID = Convert.ToDecimal(txtTN_Ten.SelectedValue);
                    oND.NGAYGIAO = (String.IsNullOrEmpty(txtN_Ngaygiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtN_Ngaygiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    DM_DATAGROUP oG = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.TRUONGHOP_GIAONHAN).FirstOrDefault();

                    DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.GROUPID == oG.ID && x.MA == hddTHGN.Value).FirstOrDefault();
                    if (oIT != null)
                    {
                        oND.TRUONGHOPGIAONHANID = oIT.ID;
                    }
                    else
                    {
                        oND.TRUONGHOPGIAONHANID = 266;
                    }
                    oND.NGUOIGIAOID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                    oND.GHICHU_GIAO = txtTN_ghichu.Text;
                    oND.TRANGTHAI = 0;// 0: Chuyển chờ nhận, 1: Nhận
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.NGAYTAO = DateTime.Now;
                    dt.APS_CHUYEN_NHAN_AN.Add(oND);
                    dt.SaveChanges();
                    APS_CHUYEN_NHAN_AN_BL _chuyenNhanAnBl = new APS_CHUYEN_NHAN_AN_BL();
                    string noidung = "";
                    APS_DON oDon = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    noidung = genNoiDung(oDon.MAGIAIDOAN.Value, DONID, noidung, rdbLoai.SelectedValue == "0" ? false : true);
                    noidung = "<b>- Lý do:</b> " + noidung + "<br/>";
                    _chuyenNhanAnBl.UPDATE_NOIDUNG_CHUYENNHANAN(oND.ID, noidung, DONID);
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";

                    //10092021 insert quản lý hồ sơ trạng thái kháng nghị đề nghị
                    new QLHS_BL().InsertHoSoLuTruCoChuyenAn(DONID, ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN, (String.IsNullOrEmpty(txtN_Ngaygiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtN_Ngaygiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault), 4, (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + ""), Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]), (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + ""), oND.TOANHANID, txtTN_Ten.SelectedItem.Text);


                    LoadGrid();
                    lbthongbaoNA.Text = "Hoàn thành chuyển án !";
                    pnDanhsach.Visible = true;
                    pnCapnhat.Visible = false;
                }
                catch (Exception ex)
                {
                    lbthongbaoNA.Text = "Lỗi: " + ex.Message;
                }
            }

        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            pnDanhsach.Visible = true;
            pnCapnhat.Visible = false;
        }


        private string genNoiDung(decimal MaGiaiDoan, decimal ID, string strNoiDung, bool isAn = true)
        {
            if (isAn)
            {
                if (MaGiaiDoan == ENUM_GIAIDOANVUAN.SOTHAM || MaGiaiDoan == ENUM_GIAIDOANVUAN.HOSO)
                {
                    bool flag = false;

                    List<APS_SOTHAM_KHANGCAO> lstkc = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && (x.TINHTRANG_GIAIQUYET == 0 || x.TINHTRANG_GIAIQUYET == null)).OrderBy(y => y.ISQUAHAN).ToList();
                    List<APS_SOTHAM_KHANGNGHI> lstkn = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && (x.TINHTRANG_GIAIQUYET == 0 || x.TINHTRANG_GIAIQUYET == null)).ToList();
                    APS_SOTHAM_KHANGCAO okc = lstkc.OrderByDescending(y => y.ISQUAHAN).FirstOrDefault();
                    if (lstkc.Count > 0 && lstkn.Count > 0)
                    {

                        if (okc.ISQUAHAN == 1)
                            strNoiDung = " Do có đề nghị xem xét lại và kháng nghị <b><span style='color: red'>(KC quá hạn)</span></b>";
                        else
                            strNoiDung = " Do có đề nghị xem xét lại và kháng nghị";

                    }
                    else if (lstkc.Count > 0 && lstkn.Count == 0)
                    {
                        if (okc.ISQUAHAN == 1)
                            if (okc.GQ_TINHTRANG == 1)
                            {
                                strNoiDung = "Do có đề nghị  xem xét lại <b><span style='color: red'>(KC quá hạn đã duyệt)</span></b>";
                            }
                            else
                            {
                                strNoiDung = "Do có đề nghị xem xét lại <b><span style='color: red'>(KC quá hạn chưa duyệt)</span></b>";
                                //manhnd them chỉ cần có 1 đề nghị đúng hạn là cho chuyển
                                decimal ck = 0;
                                foreach (var item in lstkc)
                                {
                                    if (item.ISQUAHAN == 0)
                                        ck = 1;
                                    break;
                                }
                                flag = true;
                            }

                        else
                            strNoiDung = "Do có đề nghị xem xét lại";
                    }
                    else if (lstkc.Count == 0 && lstkn.Count > 0)
                    {
                        strNoiDung = "Do có kháng nghị";
                        flag = true;
                    }


                    if (flag == false)
                    {

                        DM_QD_LOAI oDMQD = dt.DM_QD_LOAI.Where(x => x.MA == "CVA").FirstOrDefault();
                        if (oDMQD != null)
                        {
                            decimal IDToa = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            APS_SOTHAM_QUYETDINH oQD = dt.APS_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && x.LOAIQDID == oDMQD.ID && x.TOAANID == IDToa).OrderByDescending(y => y.NGAYQD).FirstOrDefault();
                            if (oQD != null)
                            {
                                strNoiDung = "Không thuộc thẩm quyền xét xử";
                                flag = true;
                            }
                        }
                    }

                }
                else if (MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM)
                {

                    List<APS_PHUCTHAM_BANAN> lstba = dt.APS_PHUCTHAM_BANAN.Where(x => x.DONID == ID && (x.KETQUAPHUCTHAMID == 4 || x.KETQUAPHUCTHAMID == 22)).ToList();
                    List<APS_PHUCTHAM_QUYETDINH> lstqd = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.DONID == ID && x.KETQUAID == 103).ToList();
                    if (lstba.Count > 0 || lstqd.Count > 0)
                    {
                        strNoiDung = "Huỷ bản án, quyết định sơ thẩm và chuyển hồ sơ vụ án xét xử lại";
                    }

                }
                else if (MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                {


                    List<APS_KCKNQDK_PHUCTHAM_QUYETDINH> lstqd = DataExtensions.GetAllWithClause<APS_KCKNQDK_PHUCTHAM_QUYETDINH>($"DONID = {ID} AND KETQUAID IN (101,102,103)");
                    if (lstqd.Count > 0)
                    {
                        var qd = lstqd.FirstOrDefault();
                        strNoiDung = qd.KETQUAID == 101 ?
                            "Giữ nguyên quyết định của Tòa án cấp sơ thẩm" :
                            (qd.KETQUAID == 102 ?
                            "Sửa quyết định của Tòa án cấp sơ thẩm" :
                            "Hủy quyết định của Tòa án cấp sơ thẩm và chuyển hồ sơ vụ án cho Tòa án cấp sơ thẩm để tiếp tục giải quyết vụ án");
                    }
                    else
                    {
                        strNoiDung = "Đình chỉ giải quyết phúc thẩm đối với KC/KN QĐ TĐC của tòa án cấp sơ thẩm";
                    }

                }
            }
            else
            {
                APS_DON_XULY dxl = dt.APS_DON_XULY.Where(x => x.DONID == ID).OrderByDescending(x => x.ID).FirstOrDefault();
                if (string.IsNullOrEmpty(dxl?.LYDO))
                {
                    strNoiDung = "Không thuộc thẩm quyền giải quyết";
                }
                else
                    strNoiDung = dxl.LYDO;
            }

            return strNoiDung;

        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                try
                {
                    DataRowView rv = (DataRowView)e.Item.DataItem;
                    Literal lstNgaythuly = (Literal)e.Item.FindControl("lstNgaythuly");
                    //Literal lstSoQDBA = (Literal)e.Item.FindControl("lstSoQDBA");
                    Literal lstNoiDung = (Literal)e.Item.FindControl("lstNoiDung");
                    HiddenField hddLydo = (HiddenField)e.Item.FindControl("hddLydo");
                    HiddenField hddTHGiaoNhan = (HiddenField)e.Item.FindControl("hddTHGiaoNhan");
                    CheckBox chkChon = (CheckBox)e.Item.FindControl("chkChon");
                    string strID = e.Item.Cells[0].Text, strNoiDung = "";
                    decimal ID = Convert.ToDecimal(strID), MaGiaiDoan = 0;
                    APS_DON oDon = dt.APS_DON.Where(x => x.ID == ID).FirstOrDefault();
                    if (oDon != null)
                    {
                        MaGiaiDoan = oDon.MAGIAIDOAN + "" == "" ? 0 : (decimal)oDon.MAGIAIDOAN;
                    }
                    if (rdbLoai.SelectedValue == "0")//Chuyển nhận đơn
                    {
                        #region Chuyển nhận đơn
                        if (hddLydo.Value != "")
                        {
                            decimal IDTHGN = Convert.ToDecimal(hddLydo.Value);
                            DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == IDTHGN).FirstOrDefault();
                            strNoiDung = oIT.TEN;
                        }
                        else
                        {
                            APS_DON_XULY dxl = dt.APS_DON_XULY.Where(x => x.DONID == ID).OrderByDescending(x => x.ID).FirstOrDefault();
                            if (string.IsNullOrEmpty(dxl.LYDO))
                            {
                                hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHONGTHUOC_THAMQUYEN_XETXU;
                                strNoiDung = "Không thuộc thẩm quyền giải quyết";
                            }
                            else
                                strNoiDung = dxl.LYDO;
                        }
                        #endregion Chuyển nhận đơn
                    }
                    else
                    {
                        #region chuyển nhận án
                        if (MaGiaiDoan == ENUM_GIAIDOANVUAN.SOTHAM || MaGiaiDoan == ENUM_GIAIDOANVUAN.HOSO)
                        {
                            APS_SOTHAM_THULY oTL = dt.APS_SOTHAM_THULY.Where(x => x.DONID == ID).OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                            if (oTL != null) lstNgaythuly.Text = ((DateTime)oTL.NGAYTHULY).ToString("dd/MM/yyyy");
                            if (rdbTrangthai.SelectedValue == "0")
                            {
                                bool flag = false;

                                List<APS_SOTHAM_KHANGCAO> lstkc = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && (x.TINHTRANG_GIAIQUYET == 0 || x.TINHTRANG_GIAIQUYET == null)).OrderBy(y => y.ISQUAHAN).ToList();
                                List<APS_SOTHAM_KHANGNGHI> lstkn = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && (x.TINHTRANG_GIAIQUYET == 0 || x.TINHTRANG_GIAIQUYET == null)).ToList();
                                APS_SOTHAM_KHANGCAO okc = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == ID).OrderByDescending(y => y.ISQUAHAN).FirstOrDefault();
                                if (lstkc.Count > 0 && lstkn.Count > 0)
                                {
                                    //lstSoQDBA.Text = lstkc[0].SOQDBA + " - " + ((DateTime)lstkc[0].NGAYQDBA).ToString("dd/MM/yyyy");
                                    //lstSoQDBA.Text += "<br/>" + lstkn[0].SOKN + " - " + ((DateTime)lstkn[0].NGAYBANAN).ToString("dd/MM/yyyy");
                                    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHANGCAO_KHANGNGHI_PHUCTHAM;
                                    //strNoiDung = "Do có đề nghị và kháng nghị phúc thẩm";
                                    if (okc.ISQUAHAN == 1)
                                        strNoiDung = "Do có đề nghị xem xét lại và kháng nghị <b><span style='color: red'>(KC quá hạn)</span></b>";
                                    else
                                        strNoiDung = "Do có đề nghị xem xét lại và kháng nghị";

                                }
                                else if (lstkc.Count > 0 && lstkn.Count == 0)
                                {
                                    //lstSoQDBA.Text = lstkc[0].SOQDBA + " - " + ((DateTime)lstkc[0].NGAYQDBA).ToString("dd/MM/yyyy");
                                    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHANGCAO_PHUCTHAM;
                                    if (okc.ISQUAHAN == 1)
                                        if (okc.GQ_TINHTRANG == 1)
                                        {
                                            strNoiDung = "Do có đề nghị xem xét lại và kháng nghị <b><span style='color: red'>(KC quá hạn đã duyệt)</span></b>";
                                            chkChon.Enabled = true;
                                        }
                                        else
                                        {
                                            strNoiDung = " <b><span style='color: red'>(KC quá hạn chưa duyệt)</span></b>";
                                            //manhnd them chỉ cần có 1 đề nghị đúng hạn là cho chuyển
                                            decimal ck = 0;
                                            foreach (var item in lstkc)
                                            {
                                                if (item.ISQUAHAN == 0)
                                                    ck = 1;
                                                break;
                                            }
                                            if (ck == 0)
                                                chkChon.Enabled = false;
                                        }

                                    else
                                        strNoiDung = "Do có đề nghị xem xét lại";
                                }
                                else if (lstkc.Count == 0 && lstkn.Count > 0)
                                {
                                    //lstSoQDBA.Text = lstkn[0].SOKN + " - " + ((DateTime)lstkn[0].NGAYBANAN).ToString("dd/MM/yyyy");
                                    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHANGNGHI_PHUCTHAM;
                                    strNoiDung = "Do có kháng nghị";
                                }

                                if (flag == false)
                                {

                                    DM_QD_LOAI oDMQD = dt.DM_QD_LOAI.Where(x => x.MA == "CVA").FirstOrDefault();
                                    if (oDMQD != null)
                                    {
                                        decimal IDToa = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                                        APS_SOTHAM_QUYETDINH oQD = dt.APS_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && x.LOAIQDID == oDMQD.ID && x.TOAANID == IDToa).OrderByDescending(y => y.NGAYQD).FirstOrDefault();
                                        if (oQD != null)
                                        {
                                            //lstSoQDBA.Text = oQD.SOQD + " - " + ((DateTime)oQD.NGAYQD).ToString("dd/MM/yyyy");
                                            hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHONGTHUOC_THAMQUYEN_XETXU;
                                            strNoiDung = "Không thuộc thẩm quyền xét xử";
                                            flag = true;
                                        }
                                    }
                                }
                            }
                            else
                            {
                                if (hddLydo.Value != "")
                                {
                                    decimal IDTHGN = Convert.ToDecimal(hddLydo.Value);
                                    DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == IDTHGN).FirstOrDefault();
                                    strNoiDung = oIT.TEN;
                                }
                                else
                                {
                                    APS_DON_XULY dxl = dt.APS_DON_XULY.Where(x => x.DONID == ID).FirstOrDefault();
                                    strNoiDung = dxl.LYDO;
                                }
                            }
                        }
                        else if (MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM)
                        {
                            APS_PHUCTHAM_THULY oTL = dt.APS_PHUCTHAM_THULY.Where(x => x.DONID == ID).OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                            if (oTL != null) lstNgaythuly.Text = ((DateTime)oTL.NGAYTHULY).ToString("dd/MM/yyyy");
                            if (rdbTrangthai.SelectedValue == "0")
                            {
                                //DM_KETQUA_PHUCTHAM oKQPT = dt.DM_KETQUA_PHUCTHAM.Where(x => x.MA == "06").FirstOrDefault();
                                //List<APS_PHUCTHAM_BANAN> lstba = dt.APS_PHUCTHAM_BANAN.Where(x => x.DONID == ID && x.KETQUAPHUCTHAMID == oKQPT.ID).ToList();
                                //DM_KETQUA_PHUCTHAM oKQPT2 = dt.DM_KETQUA_PHUCTHAM.Where(x => x.MA == "04").FirstOrDefault();
                                //List<APS_PHUCTHAM_BANAN> lstba2 = dt.APS_PHUCTHAM_BANAN.Where(x => x.DONID == ID && x.KETQUAPHUCTHAMID == oKQPT2.ID).ToList();
                                //List<APS_PHUCTHAM_QUYETDINH> lstQD = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.DONID == ID && x.KETQUAID == 103).ToList();
                                //if (lstba.Count > 0 || lstba2.Count > 0 || lstQD.Count > 0)
                                //{
                                //    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM;
                                //    strNoiDung = "Huỷ bản án, quyết định sơ thẩm và chuyển hồ sơ vụ án xét xử lại";
                                //}

                                List<APS_PHUCTHAM_BANAN> lstba = dt.APS_PHUCTHAM_BANAN.Where(x => x.DONID == ID && (x.KETQUAPHUCTHAMID == 4 || x.KETQUAPHUCTHAMID == 22)).ToList();
                                List<APS_PHUCTHAM_QUYETDINH> lstqd = dt.APS_PHUCTHAM_QUYETDINH.Where(x => x.DONID == ID && x.KETQUAID == 103).ToList();
                                if (lstba.Count > 0 || lstqd.Count > 0)
                                {
                                    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM;
                                    strNoiDung = "Huỷ bản án, quyết định sơ thẩm và chuyển hồ sơ vụ án xét xử lại";
                                }
                            }
                            else
                            {
                                if (hddLydo.Value != "")
                                {
                                    decimal IDTHGN = Convert.ToDecimal(hddLydo.Value);
                                    DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == IDTHGN).FirstOrDefault();
                                    strNoiDung = oIT.TEN;
                                }
                                else
                                {
                                    APS_DON_XULY dxl = dt.APS_DON_XULY.Where(x => x.DONID == ID).FirstOrDefault();
                                    strNoiDung = dxl.LYDO;
                                }
                            }
                        }
                        else if (MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                        {
                            //APS_KCKNQDK_PHUCTHAM_THULY oTL = dt.APS_KCKNQDK_PHUCTHAM_THULY.Where(x => x.DONID == ID).OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                            APS_KCKNQDK_PHUCTHAM_THULY oTL = DataExtensions.GetAllByDonId<APS_KCKNQDK_PHUCTHAM_THULY>(ID).OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                            if (oTL != null) lstNgaythuly.Text = ((DateTime)oTL.NGAYTHULY).ToString("dd/MM/yyyy");
                            if (rdbTrangthai.SelectedValue == "0")
                            {

                                List<APS_KCKNQDK_PHUCTHAM_QUYETDINH> lstqd = DataExtensions.GetAllWithClause<APS_KCKNQDK_PHUCTHAM_QUYETDINH>($"DONID = {ID} AND KETQUAID IN (101,102,103)");
                                if (lstqd.Count > 0)
                                {
                                    var qd = lstqd.FirstOrDefault();
                                    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM;
                                    strNoiDung = qd.KETQUAID == 101 ?
                                        "Giữ nguyên quyết định của Tòa án cấp sơ thẩm" :
                                        (qd.KETQUAID == 102 ?
                                        "Sửa quyết định của Tòa án cấp sơ thẩm" :
                                        "Hủy quyết định của Tòa án cấp sơ thẩm và chuyển hồ sơ vụ án cho Tòa án cấp sơ thẩm để tiếp tục giải quyết vụ án");
                                }
                                else
                                {
                                    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM;
                                    strNoiDung = "Đình chỉ giải quyết phúc thẩm đối với KC/KN QĐ TĐC của tòa án cấp sơ thẩm";
                                }   
                            }
                            else
                            {
                                if (hddLydo.Value != "")
                                {
                                    decimal IDTHGN = Convert.ToDecimal(hddLydo.Value);
                                    DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == IDTHGN).FirstOrDefault();
                                    strNoiDung = oIT.TEN;
                                }
                                else
                                {
                                    APS_DON_XULY dxl = dt.APS_DON_XULY.Where(x => x.DONID == ID).FirstOrDefault();
                                    strNoiDung = dxl.LYDO;
                                }
                            }
                        }
                        #endregion chuyển nhận án
                    }
                    hddTHGiaoNhan.Value = strNoiDung;
                    lstNoiDung.Text = "<b>- Lý do:</b> " + strNoiDung + "<br/>" + rv["v_NOIDUNG"];
                    if (rdbTrangthai.SelectedValue == "1" && rv["v_NOIDUNG"].ToString().Contains("- Lý do:"))
                    {
                        lstNoiDung.Text = rv["v_NOIDUNG"].ToString();
                    }
                    LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                    if (rdbTrangthai.SelectedValue == "1")
                        lbtHuyChuyen.Visible = true;
                    else
                        lbtHuyChuyen.Visible = false;
                }
                catch (Exception ex)
                {
                    lbthongbao.Text = "Lỗi: " + ex.Message;
                }
            }
        }
        protected void rdbTrangthai_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void cmdHuyChuyen_Click(object sender, EventArgs e)
        {
            try
            {
                List<decimal> lstDonID = new List<decimal>();
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        var DonID = Convert.ToDecimal(chkChon.ToolTip);
                        lstDonID.Add(DonID);
                        //break;
                    }
                }

                HuyChuyen(lstDonID);

            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal DonID = Convert.ToDecimal(e.CommandArgument.ToString());
                List<decimal> lstDonID = new List<decimal>();
                lstDonID.Add(DonID);
                switch (e.CommandName)
                {
                    case "HuyChuyen":
                        HuyChuyen(lstDonID);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void HuyChuyen(List<decimal> lstChuyenAnID)
        {
            APS_CHUYEN_NHAN_AN_BL Bl = new APS_CHUYEN_NHAN_AN_BL();
            //for (int i = 0; i < lstDonID.Count; i++)
            //{
            //    string Msg_Ex = "Không được phép hủy chuyển án.";
            //    var Id = lstDonID[i];
            //    string rs = Bl.Check_NhanAn(Id, Msg_Ex);
            //    if (rs == "") // Án chưa nhận
            //    {
            //    }
            //    else
            //    {
            //        lbthongbao.Text = rs;
            //        return;
            //    }
            //}
            //// Án chưa được nhận mới cho phép hủy chuyển án.
            //for (int i = 0; i < lstDonID.Count; i++)
            //{
            //    var DonID = lstDonID[i];
            //    string Message_Ex = "Không được phép hủy chuyển án.";
            //    string Result = Bl.Check_NhanAn(DonID, Message_Ex);
            //    if (Result == "") // Án chưa nhận
            //    {
            //        APS_CHUYEN_NHAN_AN ObjChuyenNhan = dt.APS_CHUYEN_NHAN_AN.Where(x => x.VUANID == DonID).FirstOrDefault();
            //        if (ObjChuyenNhan != null)
            //        {
            //            dt.APS_CHUYEN_NHAN_AN.Remove(ObjChuyenNhan);
            //            dt.SaveChanges();
            //            dgList.CurrentPageIndex = 0;
            //            hddPageIndex.Value = "1";

            //            //10092021 insert quản lý hồ sơ trạng thái kháng nghị đề nghị
            //            new QLHS_BL().DeleteHoSoLuTruCoChuyenAn(DonID, ENUM_LOAIVUVIEC_NUMBER.AN_PHASAN);


            //        }
            //    }
            //    else
            //    {
            //        lbthongbao.Text = Result;
            //    }
            //}
            string nd = "";
            for (int i = 0; i < lstChuyenAnID.Count; i++)
            {
                string Msg_Ex = "Không được phép hủy chuyển án.";
                var ChuyenAnId = lstChuyenAnID[i];
                APS_CHUYEN_NHAN_AN oChuyenAn = dt.APS_CHUYEN_NHAN_AN.Where(x => x.ID == ChuyenAnId).FirstOrDefault();
                APS_DON_XULY dxl = dt.APS_DON_XULY.Where(x => x.DONID == oChuyenAn.VUANID).FirstOrDefault();
                if (oChuyenAn != null)
                {
                    decimal DonID = oChuyenAn.VUANID.Value;
                    // string rs = Bl.Check_NhanAn(DonID, Msg_Ex, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (oChuyenAn.TRANGTHAI != 1) // Án chưa nhận
                    {
                        dt.APS_CHUYEN_NHAN_AN.Remove(oChuyenAn);
                        dt.SaveChanges();
                        dgList.CurrentPageIndex = 0;
                        hddPageIndex.Value = "1";
                        //10092021 insert quản lý hồ sơ trạng thái kháng nghị đề nghị
                        new QLHS_BL().DeleteHoSoLuTruCoChuyenAn(DonID, ENUM_LOAIVUVIEC_NUMBER.AN_DANSU);

                        //manhnd 10/12/2021 cap nhat lai MAGIAIDON sau khi huy chuyen
                        //APS_DON_GIAIDOAN oGD = dt.APS_DON_GIAIDOAN.Where(x => x.DONID == DonID && x.TOAANID == oChuyenAn.TOACHUYENID).FirstOrDefault();
                        //APS_DON oDon = dt.APS_DON.Where(X => X.ID == DonID).FirstOrDefault();
                        //oDon.MAGIAIDOAN = oGD.MAGIAIDOAN;
                        //dt.SaveChanges();
                    }
                    else
                    {
                        string Result = "Án đã được ";
                        DM_TOAAN ObjToaAn = dt.DM_TOAAN.Where(x => x.ID == oChuyenAn.TOANHANID).FirstOrDefault();
                        if (ObjToaAn != null)
                        {
                            Result += ObjToaAn.MA_TEN;
                        }
                        Result += " nhận. " + Msg_Ex;
                        lbthongbao.Text = Result;
                        return;
                    }
                }
                if (dxl.LOAIGIAIQUYET == 1)
                {
                    nd = "Hủy chuyển đơn thành công.";
                }
                else
                {
                    nd = "Hủy chuyển án thành công.";
                }
            }
            LoadGrid();
            lbthongbao.Text = "Hủy chuyển án thành công.";
        }


        protected void rptCapNhat_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            var hddVuViecIDCurrent = e.Item.FindControl("hddVuViecID") as HiddenField;
            var hddTN_ID = e.Item.FindControl("hddTN_ID") as HiddenField;
            var isEnableToaAnTen = e.Item.FindControl("isEnableToaAnTen") as HiddenField;

            DropDownList selectList = e.Item.FindControl("txtTN_Ten") as DropDownList;

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                selectList.Items.Clear();
                selectList.Enabled = true;

                //set lại dropdowlist
                DM_TOAAN toaAn = new DM_TOAAN();
                decimal toaanST = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal toacapchaID = 0;
                toaAn = dt.DM_TOAAN.Where(x => x.ID == toaanST).FirstOrDefault();
                if (toaAn != null)
                {
                    toacapchaID = toaAn.CAPCHAID == null ? 0 : (decimal)toaAn.CAPCHAID;
                }
                if (toacapchaID == 0)
                {

                    toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == toaanST).FirstOrDefault<DM_TOAAN>();

                }
                else
                {
                    toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == toacapchaID).FirstOrDefault<DM_TOAAN>();
                }

                selectList.Items.Add(new ListItem(toaAn.TEN, toaAn.ID.ToString()));

                //List<string> arr = new List<string>(); 
                DM_TOAAN_BL obj = new DM_TOAAN_BL();
                DataTable tbl = obj.SearchTop(10000000, "");
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    foreach (DataRow row in tbl.Rows)
                    {
                        if (row["ID"].ToString() != toaAn.ID.ToString())
                        {
                            selectList.Items.Add(new ListItem(row["MA_TEN"].ToString(), row["ID"].ToString()));
                        }

                        //arr.Add(row["ID"].ToString() + "_" + row["MA_TEN"]);
                    }
                }
                if (!string.IsNullOrEmpty(hddTN_ID.Value))
                {
                    selectList.SelectedValue = hddTN_ID.Value;
                }
                if (isEnableToaAnTen.Value == "False")
                {
                    selectList.Enabled = false;
                }
            }
        }
    }
}