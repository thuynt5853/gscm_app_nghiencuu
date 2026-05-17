using BL.GSTP;
using BL.GSTP.AHC;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.AHC;
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

namespace WEB.GSTP.QLAN.AHC.ChuyenNhanAn
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
            DataTable oDT = oBL.HC_CHUYENAN(vDonViID, txtTenToa.Text.Trim(), txtMaVuViec.Text.Trim(), txtTenVuViec.Text.Trim(), txtSoquyetdinh.Text.Trim(), txtSobanan.Text.Trim(), dFrom, dTo, txtTenduongsu.Text.Trim(), Convert.ToDecimal(rdbTrangthai.SelectedValue), Convert.ToDecimal(rdbLoai.SelectedValue));

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
                        AHC_DON_XULY donXuLy = dt.AHC_DON_XULY.Where(x => x.DONID == IDVUAN).FirstOrDefault();
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
                                toaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnCapChaID).FirstOrDefault<DM_TOAAN>();
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
                 
                        AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == IDVUAN).FirstOrDefault();
                        if (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                        {
                            AHC_CHUYEN_NHAN_AN_BL chuyenNhanBL = new AHC_CHUYEN_NHAN_AN_BL();
                            decimal donIdOld = chuyenNhanBL.getDonIdOld(oDon.ID);
                            AHC_DON oDonOld = dt.AHC_DON.Where(x => x.ID == donIdOld).FirstOrDefault();
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
            //            AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == IDVUAN).FirstOrDefault();
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
                    AHC_CHUYEN_NHAN_AN oND = new AHC_CHUYEN_NHAN_AN();
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
                    // update 130825
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.AHC_CHUYEN_NHAN_AN.Add(oND);
                    dt.SaveChanges();
                    AHC_CHUYEN_NHAN_AN_BL _chuyenNhanAnBl = new AHC_CHUYEN_NHAN_AN_BL();
                    string noidung = "";
                    AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    noidung = genNoiDung(oDon.MAGIAIDOAN.Value, DONID, noidung, rdbLoai.SelectedValue == "0" ? false : true);
                    noidung = "<b>- Lý do:</b> " + noidung + "<br/>";
                    _chuyenNhanAnBl.UPDATE_NOIDUNG_CHUYENNHANAN(oND.ID, noidung, DONID);
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";

                    //10092021 insert quản lý hồ sơ trạng thái kháng nghị kháng cáo
                    new QLHS_BL().InsertHoSoLuTruCoChuyenAn(DONID, ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH, (String.IsNullOrEmpty(txtN_Ngaygiao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(txtN_Ngaygiao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault), 4, (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + ""), Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]), (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + ""), oND.TOANHANID, txtTN_Ten.SelectedItem.Text);


                    LoadGrid();
                    lbthongbao.Text = "Chuyển thành công.";
                    //lbthongbaoNA.Text = "Hoàn thành chuyển án !";
                    pnDanhsach.Visible = true;
                    pnCapnhat.Visible = false;
                }
                catch (Exception ex)
                {
                    lbthongbaoNA.Text = "Lỗi: " + ex.Message;
                }
            }

        }
        private string genNoiDung(decimal MaGiaiDoan, decimal ID, string strNoiDung, bool isAn = true)
        {
            if (isAn)
            {
                if (MaGiaiDoan == ENUM_GIAIDOANVUAN.SOTHAM || MaGiaiDoan == ENUM_GIAIDOANVUAN.HOSO)
                {
                    bool flag = false;

                    List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && (x.TINHTRANG_GIAIQUYET == 0 || x.TINHTRANG_GIAIQUYET == null)).OrderBy(y => y.ISQUAHAN).ToList();
                    List<AHC_SOTHAM_KHANGNGHI> lstkn = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && (x.TINHTRANG_GIAIQUYET == 0 || x.TINHTRANG_GIAIQUYET == null)).ToList();
                    AHC_SOTHAM_KHANGCAO okc = lstkc.OrderByDescending(y => y.ISQUAHAN).FirstOrDefault();
                    if (lstkc.Count > 0 && lstkn.Count > 0)
                    {

                        if (okc.ISQUAHAN == 1)
                            strNoiDung = "Do có kháng cáo và kháng nghị phúc thẩm <b><span style='color: red'>(KC quá hạn)</span></b>";
                        else
                            strNoiDung = "Do có kháng cáo và kháng nghị phúc thẩm";

                    }
                    else if (lstkc.Count > 0 && lstkn.Count == 0)
                    {
                        if (okc.ISQUAHAN == 1)
                            if (okc.GQ_TINHTRANG == 1)
                            {
                                strNoiDung = "Do có kháng cáo phúc thẩm <b><span style='color: red'>(KC quá hạn đã duyệt)</span></b>";
                            }
                            else
                            {
                                strNoiDung = "Do có kháng cáo phúc thẩm <b><span style='color: red'>(KC quá hạn chưa duyệt)</span></b>";
                                //manhnd them chỉ cần có 1 kháng cáo đúng hạn là cho chuyển
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
                            strNoiDung = "Do có kháng cáo phúc thẩm";
                    }
                    else if (lstkc.Count == 0 && lstkn.Count > 0)
                    {
                        strNoiDung = "Do có kháng nghị phúc thẩm";
                        flag = true;
                    }


                    if (flag == false)
                    {

                        DM_QD_LOAI oDMQD = dt.DM_QD_LOAI.Where(x => x.MA == "CVA").FirstOrDefault();
                        if (oDMQD != null)
                        {
                            decimal IDToa = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                            AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && x.LOAIQDID == oDMQD.ID && x.TOAANID == IDToa).OrderByDescending(y => y.NGAYQD).FirstOrDefault();
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

                    List<AHC_PHUCTHAM_BANAN> lstba = dt.AHC_PHUCTHAM_BANAN.Where(x => x.DONID == ID && (x.KETQUAPHUCTHAMID == 4 || x.KETQUAPHUCTHAMID == 22)).ToList();
                    List<AHC_PHUCTHAM_QUYETDINH> lstqd = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == ID && x.KETQUAID == 103).ToList();
                    if (lstba.Count > 0 || lstqd.Count > 0)
                    {
                        strNoiDung = "Huỷ bản án, quyết định sơ thẩm và chuyển hồ sơ vụ án xét xử lại";
                    }

                }
                else if (MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                {


                    List<AHC_KCKNQDK_PHUCTHAM_QUYETDINH> lstqd = DataExtensions.GetAllWithClause<AHC_KCKNQDK_PHUCTHAM_QUYETDINH>($"DONID = {ID} AND KETQUAID IN (101,102,103)");
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
                AHC_DON_XULY dxl = dt.AHC_DON_XULY.Where(x => x.DONID == ID).OrderByDescending(x => x.ID).FirstOrDefault();
                if (string.IsNullOrEmpty(dxl?.LYDO))
                {
                    strNoiDung = "Không thuộc thẩm quyền giải quyết";
                }
                else
                    strNoiDung = dxl.LYDO;
            }
            return strNoiDung;

        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            pnDanhsach.Visible = true;
            pnCapnhat.Visible = false;
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
                    AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == ID).FirstOrDefault();
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
                            AHC_DON_XULY dxl = dt.AHC_DON_XULY.Where(x => x.DONID == ID).OrderByDescending(x => x.ID).FirstOrDefault();
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
                            AHC_SOTHAM_THULY oTL = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == ID).OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                            if (oTL != null) lstNgaythuly.Text = ((DateTime)oTL.NGAYTHULY).ToString("dd/MM/yyyy");
                            if (rdbTrangthai.SelectedValue == "0")
                            {
                                bool flag = false;

                                List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == ID && (x.TINHTRANG_GIAIQUYET == 0 || x.TINHTRANG_GIAIQUYET == null)).OrderBy(y => y.ISQUAHAN).ToList();
                                List<AHC_SOTHAM_KHANGNGHI> lstkn = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == ID && (x.TINHTRANG_GIAIQUYET == 0 || x.TINHTRANG_GIAIQUYET == null)).ToList();
                                AHC_SOTHAM_KHANGCAO okc = lstkc.OrderByDescending(y => y.ISQUAHAN).FirstOrDefault();
                                if (lstkc.Count > 0 && lstkn.Count > 0)
                                {
                                    //lstSoQDBA.Text = lstkc[0].SOQDBA + " - " + ((DateTime)lstkc[0].NGAYQDBA).ToString("dd/MM/yyyy");
                                    //lstSoQDBA.Text += "<br/>" + lstkn[0].SOKN + " - " + ((DateTime)lstkn[0].NGAYBANAN).ToString("dd/MM/yyyy");
                                    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHANGCAO_KHANGNGHI_PHUCTHAM;
                                    //strNoiDung = "Do có kháng cáo và kháng nghị phúc thẩm";
                                    if (okc.ISQUAHAN == 1)
                                        strNoiDung = "Do có kháng cáo và kháng nghị phúc thẩm <b><span style='color: red'>(KC quá hạn)</span></b>";
                                    else
                                        strNoiDung = "Do có kháng cáo và kháng nghị phúc thẩm";

                                }
                                else if (lstkc.Count > 0 && lstkn.Count == 0)
                                {
                                    //lstSoQDBA.Text = lstkc[0].SOQDBA + " - " + ((DateTime)lstkc[0].NGAYQDBA).ToString("dd/MM/yyyy");
                                    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHANGCAO_PHUCTHAM;
                                    if (okc.ISQUAHAN == 1)
                                        if (okc.GQ_TINHTRANG == 1)
                                        {
                                            strNoiDung = "Do có kháng cáo phúc thẩm <b><span style='color: red'>(KC quá hạn đã duyệt)</span></b>";
                                            chkChon.Enabled = true;
                                        }
                                        else
                                        {
                                            strNoiDung = "Do có kháng cáo phúc thẩm <b><span style='color: red'>(KC quá hạn chưa duyệt)</span></b>";
                                            //manhnd them chỉ cần có 1 kháng cáo đúng hạn là cho chuyển
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
                                        strNoiDung = "Do có kháng cáo phúc thẩm";
                                }
                                else if (lstkc.Count == 0 && lstkn.Count > 0)
                                {
                                    //lstSoQDBA.Text = lstkn[0].SOKN + " - " + ((DateTime)lstkn[0].NGAYBANAN).ToString("dd/MM/yyyy");
                                    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.KHANGNGHI_PHUCTHAM;
                                    strNoiDung = "Do có kháng nghị phúc thẩm";
                                }


                                if (flag == false)
                                {

                                    DM_QD_LOAI oDMQD = dt.DM_QD_LOAI.Where(x => x.MA == "CVA").FirstOrDefault();
                                    if (oDMQD != null)
                                    {
                                        decimal IDToa = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                                        AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == ID && x.LOAIQDID == oDMQD.ID && x.TOAANID == IDToa).OrderByDescending(y => y.NGAYQD).FirstOrDefault();
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
                            }
                        }
                        else if (MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM)
                        {
                            AHC_PHUCTHAM_THULY oTL = dt.AHC_PHUCTHAM_THULY.Where(x => x.DONID == ID).OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                            if (oTL != null) lstNgaythuly.Text = ((DateTime)oTL.NGAYTHULY).ToString("dd/MM/yyyy");
                            if (rdbTrangthai.SelectedValue == "0")
                            {
                                //DM_KETQUA_PHUCTHAM oKQPT = dt.DM_KETQUA_PHUCTHAM.Where(x => x.MA == "06").FirstOrDefault();
                                //List<AHC_PHUCTHAM_BANAN> lstba = dt.AHC_PHUCTHAM_BANAN.Where(x => x.DONID == ID && x.KETQUAPHUCTHAMID == oKQPT.ID).ToList();
                                //DM_KETQUA_PHUCTHAM oKQPT2 = dt.DM_KETQUA_PHUCTHAM.Where(x => x.MA == "04").FirstOrDefault();
                                //List<AHC_PHUCTHAM_BANAN> lstba2 = dt.AHC_PHUCTHAM_BANAN.Where(x => x.DONID == ID && x.KETQUAPHUCTHAMID == oKQPT2.ID).ToList();
                                //List<AHC_PHUCTHAM_QUYETDINH> lstQD = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == ID && x.KETQUAID == 103).ToList();
                                //if (lstba.Count > 0 || lstba2.Count > 0 || lstQD.Count > 0)
                                //{
                                //    hddLydo.Value = ENUM_TRUONGHOP_GIAONHAN.XETXULAI_CAPSOTHAM;
                                //    strNoiDung = "Huỷ bản án, quyết định sơ thẩm và chuyển hồ sơ vụ án xét xử lại";
                                //}

                                List<AHC_PHUCTHAM_BANAN> lstba = dt.AHC_PHUCTHAM_BANAN.Where(x => x.DONID == ID && (x.KETQUAPHUCTHAMID == 4 || x.KETQUAPHUCTHAMID == 22)).ToList();
                                List<AHC_PHUCTHAM_QUYETDINH> lstqd = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == ID && x.KETQUAID == 103).ToList();
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
                            }
                        }
                        else if (MaGiaiDoan == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                        {
                            AHC_KCKNQDK_PHUCTHAM_THULY oTL = DataExtensions.GetAllByDonId<AHC_KCKNQDK_PHUCTHAM_THULY>(ID).OrderByDescending(y => y.NGAYTHULY).Take(1).FirstOrDefault();
                            if (oTL != null) lstNgaythuly.Text = ((DateTime)oTL.NGAYTHULY).ToString("dd/MM/yyyy");
                            if (rdbTrangthai.SelectedValue == "0")
                            {

                                List<AHC_KCKNQDK_PHUCTHAM_QUYETDINH> lstqd = DataExtensions.GetAllWithClause<AHC_KCKNQDK_PHUCTHAM_QUYETDINH>($"DONID = {ID} AND KETQUAID IN (101,102,103)");
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
                                    AHC_DON_XULY dxl = dt.AHC_DON_XULY.Where(x => x.DONID == ID).FirstOrDefault();
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
                decimal nhanAnId = Convert.ToDecimal(e.CommandArgument.ToString());
                List<decimal> lstnhanAnId = new List<decimal>();
                lstnhanAnId.Add(nhanAnId);
                switch (e.CommandName)
                {
                    case "HuyChuyen":
                        HuyChuyen(lstnhanAnId);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void HuyChuyen(List<decimal> lstChuyenAnID)
        {
            AHC_CHUYEN_NHAN_AN_BL Bl = new AHC_CHUYEN_NHAN_AN_BL();
            string nd = "";

            for (int i = 0; i < lstChuyenAnID.Count; i++)
            {
                string Msg_Ex = "Không được phép hủy chuyển án.";
                var ChuyenAnId = lstChuyenAnID[i];
                AHC_CHUYEN_NHAN_AN oChuyenAn = dt.AHC_CHUYEN_NHAN_AN.Where(x => x.ID == ChuyenAnId).FirstOrDefault();
                AHC_DON_XULY dxl = dt.AHC_DON_XULY.Where(x => x.DONID == oChuyenAn.VUANID).FirstOrDefault();
                if (oChuyenAn != null)
                {
                    if (oChuyenAn.TRANGTHAI != 1) // Án chưa nhận
                    {
                        decimal DonID = oChuyenAn.VUANID.Value;
                        dt.AHC_CHUYEN_NHAN_AN.Remove(oChuyenAn);
                        dt.SaveChanges();
                        dgList.CurrentPageIndex = 0;
                        hddPageIndex.Value = "1";
                        new QLHS_BL().DeleteHoSoLuTruCoChuyenAn(DonID, ENUM_LOAIVUVIEC_NUMBER.AN_HANHCHINH);

                        AHC_DON_GIAIDOAN oGD = dt.AHC_DON_GIAIDOAN.Where(x => x.DONID == DonID && x.TOAANID == oChuyenAn.TOACHUYENID).FirstOrDefault();

                        AHC_DON oDon = dt.AHC_DON.Where(X => X.ID == DonID).FirstOrDefault();
                        if(oGD == null)
                        {
                            oGD = dt.AHC_DON_GIAIDOAN.Where(x => x.DONID == DonID && x.TOAPHUCTHAMID == oChuyenAn.TOACHUYENID).FirstOrDefault();
                        }
                        oDon.MAGIAIDOAN = oGD.MAGIAIDOAN;
                        dt.SaveChanges();

/*                        if (oDon != null && oDon.MAGIAIDOAN != null && oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                        {
                            oGD = dt.AHC_DON_GIAIDOAN.Where(x => x.DONID == DonID && x.TOAANID == oChuyenAn.TOACHUYENID).FirstOrDefault();
                            oDon.MAGIAIDOAN = oGD.MAGIAIDOAN;
                            dt.SaveChanges();
                        }
                        else if (oDon != null && oDon.MAGIAIDOAN != null)
                        {
                            oGD = dt.AHC_DON_GIAIDOAN.Where(x => x.DONID == DonID && x.TOAPHUCTHAMID == oChuyenAn.TOANHANID).FirstOrDefault();
                            oDon.MAGIAIDOAN = oGD.MAGIAIDOAN;
                            dt.SaveChanges();
                        }*/
                    }
                    else
                    {
                        string Result = "Án đã được ";
                        if (dxl.LOAIGIAIQUYET == 1)
                        {
                            Result = "Đơn đã được ";
                        }
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
            lbthongbao.Text = nd;
        }


        protected void rptCapNhat_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            var hddVuViecIDCurrent = e.Item.FindControl("hddVuViecID") as HiddenField;
            var hddTN_ID = e.Item.FindControl("hddTN_ID") as HiddenField;
            var isEnableToaAnTen = e.Item.FindControl("isEnableToaAnTen") as HiddenField;
            HiddenField hddLydo = (HiddenField)e.Item.FindControl("hddLydo");
            DropDownList selectList = e.Item.FindControl("txtTN_Ten") as DropDownList;

            decimal idVuviec = Convert.ToDecimal(hddVuViecIDCurrent.Value);
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                AHC_DON ald = dt.AHC_DON.Where(x => x.ID == idVuviec).FirstOrDefault();

                selectList.Items.Clear();
                selectList.Enabled = true;
                //set lại dropdowlist
                DM_TOAAN toaAn = new DM_TOAAN();
                decimal toaanST = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal toacapchaID = 0;
                toaAn = dt.DM_TOAAN.Where(x => x.ID == toaanST && x.HIEULUC == 1).FirstOrDefault();
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

                if (!string.IsNullOrEmpty(hddTN_ID.Value))
                {
                    toacapchaID = Convert.ToDecimal(hddTN_ID.Value);
                    toaAn = dt.DM_TOAAN.Where(x => x.HIEULUC == 1 && x.ID == toacapchaID).FirstOrDefault<DM_TOAAN>();
                    BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL bl = new BL.GSTP.Danhmuc.DM_TOAAN_TACH_NHAP_MAPPING_BL();
                    DataTable dtSapNhap = bl.GETS_BY_TOAANTID(Convert.ToDecimal(hddTN_ID.Value));

                    if (dtSapNhap != null)
                    {
                        for (int i = 0; i < dtSapNhap.Rows.Count; i++)
                        {
                            if (dtSapNhap.Rows[i]["HIEULUC"].ToString() == "1")
                                if ((decimal)dtSapNhap.Rows[i]["TOAANID"] == Convert.ToDecimal(hddTN_ID.Value))
                                    selectList.Items.Insert(0, new ListItem(dtSapNhap.Rows[i]["TOTOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOTOAANID"].ToString()));
                                else
                                    selectList.Items.Insert(0, new ListItem(dtSapNhap.Rows[i]["TOAANTEN"].ToString(), dtSapNhap.Rows[i]["TOAANID"].ToString()));
                        }

                    }
                    if (toaAn != null)
                        selectList.Items.Insert(0, new ListItem(toaAn.TEN, toaAn.ID.ToString()));
                    selectList.SelectedValue = hddTN_ID.Value;
                }
                else
                {
                    if (toaAn != null)
                        selectList.Items.Insert(0, new ListItem(toaAn.TEN, toaAn.ID.ToString()));
                }
                if (isEnableToaAnTen.Value == "False")
                {

                    //selectList.Enabled = false;
                }
                else
                {

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

                }
                //if (isEnableToaAnTen.Value == "False")
                //{
                //    selectList.Enabled = false;
                //}
            }

        }


    }
}