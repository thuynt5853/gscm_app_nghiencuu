using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using BL.GSTP;
using BL.GSTP.THA;
using System.Globalization;
using System.Web.UI.WebControls;
using BL.GSTP.AHS;
using System.Configuration;
using System.IO;
using Aspose.Cells;
using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.THA;

namespace WEB.GSTP.QLAN.THA
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal CurrUserID = 0, ToaAnID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadDropTinhTrangGQ();
                    LoadDropLoai();
                    LoadGrid();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        void LoadDropLoai()
        {
            dropLoaiLuaChon.Items.Clear();
            dropLoaiLuaChon.Items.Add(new ListItem("Thuộc hệ thống quản lý án", "1"));
            dropLoaiLuaChon.Items.Add(new ListItem("Bị án được uỷ thác THA", "2"));
            //dropLoaiLuaChon.Items.Add(new ListItem("Ngoài hệ thống quản lý án", "2"));
        }

        void LoadDropTinhTrangGQ()
        {
            dropTinhTrangGQ.Items.Clear();
            dropTinhTrangGQ.Items.Add(new ListItem("--Tất cả--", "0"));
            dropTinhTrangGQ.Items.Add(new ListItem("+Chưa giải quyết", "1"));
            dropTinhTrangGQ.Items.Add(new ListItem("+Đã thụ lý", "2"));
            dropTinhTrangGQ.Items.Add(new ListItem("+Đã giải quyết", "6"));
            dropTinhTrangGQ.Items.Add(new ListItem(".....Đã có QĐ thi hành án", "3"));
            dropTinhTrangGQ.Items.Add(new ListItem(".....Đã có QĐ ủy thác thi hành án", "4"));
            dropTinhTrangGQ.Items.Add(new ListItem(".....Đã có GQ đơn/CV yêu cầu thi hành án", "5"));
            dropTinhTrangGQ.Items.Add(new ListItem("Không ra quyết định THA", "7"));
        }
        public void LoadGrid()
        {
            //int page_size = 20;
            //int pageindex = Convert.ToInt32(hddPageIndex.Value);

            //string mavuan = txtMaVuAn.Text.Trim();
            //string tenvuan = txtTenVuAn.Text.Trim();
            //string mabian = txtMaBiAn.Text.Trim();
            //string tenbian = txtTenBiAn.Text.Trim();
            //string sobanan = txtSoBanAn.Text.Trim();
            //DateTime ngaybanan = (string.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);          
            //int loai = Convert.ToInt16(dropLoaiLuaChon.SelectedValue);
            //int tinhtrangGQ = Convert.ToInt16(dropTinhTrangGQ.SelectedValue);
            ////int trangthai_thuly_tha = Convert.ToInt16(dropTrangThaiThuLyTHA.SelectedValue);
            //THA_BIAN_BL objBL = new THA_BIAN_BL();
            //DataTable tbl = null;
            //if(loai == 1)
            //    tbl = objBL.GetAnHSTrongHeThong(ToaAnID, mabian, tenbian, mavuan, tenvuan, sobanan, ngaybanan, tinhtrangGQ, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), pageindex, page_size);
            //else
            //    tbl = objBL.GetAnHSNgoaiHeThong(ToaAnID, mabian, tenbian, mavuan, tenvuan, sobanan, ngaybanan, tinhtrangGQ, txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), pageindex, page_size);

            //if (tbl != null && tbl.Rows.Count > 0)
            //{
            //    int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
            //    #region "Xác định số lượng trang"
            //    int all_page = Cls_Comon.GetTotalPage(count_all, page_size);
            //    hddTotalPage.Value = all_page.ToString();
            //    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            //    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
            //                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            //    #endregion
            //    dgList.Visible = true;
            //    dgList.DataSource = tbl;
            //    dgList.DataBind();
            //}
            //else
            //{
            //    hddTotalPage.Value = "1";
            //    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
            //               lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            //    lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            //    dgList.Visible = false;
            //   // lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            //}

            try
            {
                lbtthongbao.Text = "";
                int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
                int pageindex = Convert.ToInt32(hddPageIndex.Value);

                string mavuan = txtMaVuAn.Text.Trim();
                string tenvuan = txtTenVuAn.Text.Trim();
                string mabian = txtMaBiAn.Text.Trim();
                string tenbian = txtTenBiAn.Text.Trim();
                string sobanan = txtSoBanAn.Text.Trim();
                DateTime? ngaybanan = (string.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                int loai = Convert.ToInt32(dropLoaiLuaChon.SelectedValue);
                int tinhtrangGQ = Convert.ToInt32(dropTinhTrangGQ.SelectedValue);
                int TRANGTHAIGQ = bian_QDTHA.Checked ? 1 : 0;
                //int trangthai_thuly_tha = Convert.ToDecimal(dropTrangThaiThuLyTHA.SelectedValue);
                THA_BIAN_BL objBL = new THA_BIAN_BL();
                DataTable tbl = null;
                AHS_TONGHOPHINHPHAT ahs_tonghop = new AHS_TONGHOPHINHPHAT();
                if (loai == 1)
                {
                    tbl = objBL.GetAnHSTrongHeThong(ToaAnID, mabian, tenbian, mavuan, tenvuan, sobanan, ngaybanan, tinhtrangGQ, TRANGTHAIGQ, txtCMND.Text.Trim(), txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), pageindex, page_size);
                    foreach (DataRow row in tbl.Rows)
                    {
                        if (row["MAGIAIDOAN"] + "" == "2")
                        {
                            row["HINHPHAT_TONGHOP"] = ahs_tonghop.Tonghophinhphat_ST((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);
                        }
                        else
                        {
                            row["HINHPHAT_TONGHOP"] = ahs_tonghop.Tonghophinhphat_PT((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);
                        }
                    }
                }
                else
                {
                    tbl = objBL.GetAnHSNgoaiHeThong(ToaAnID, mabian, tenbian, mavuan, tenvuan, sobanan, ngaybanan, tinhtrangGQ, TRANGTHAIGQ, txtCMND.Text.Trim(), txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), pageindex, page_size);
                    foreach (DataRow row in tbl.Rows)
                    {
                        if (row["VUANIDOLD"] + "" != "" && row["BIANIDOLD"] + "" != "")
                        {
                            if (row["MAGIAIDOAN"] + "" == "2")
                            {
                                row["HINHPHAT_TONGHOP"] = ahs_tonghop.Tonghophinhphat_ST((decimal)row["VUANIDOLD"], (decimal)row["BIANIDOLD"]);
                            }
                            else
                            {
                                row["HINHPHAT_TONGHOP"] = ahs_tonghop.Tonghophinhphat_PT((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);
                            }
                        }
                    }
                }

                if (tbl != null && tbl.Rows.Count > 0)
                {
                    int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                    #region "Xác định số lượng trang"
                    int all_page = Cls_Comon.GetTotalPage(count_all, page_size);
                    hddTotalPage.Value = all_page.ToString();
                    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    #endregion
                    dgList.Visible = true;
                    dgList.DataSource = tbl;
                    dgList.DataBind();
                }
                else
                {
                    dgList.Visible = false;
                    int count_all = 0;
                    int all_page = Cls_Comon.GetTotalPage(count_all, page_size);
                    hddTotalPage.Value = all_page.ToString();
                    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    // lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
                }
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }


        protected void ddlPageCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount2.SelectedValue = ddlPageCount.SelectedValue;
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        protected void ddlPageCount2_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlPageCount.SelectedValue = ddlPageCount2.SelectedValue;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {

                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }
        #endregion
        //    protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //    {
        //        LinkButton lblXoaAnTich = (LinkButton)e.Item.FindControl("lblXoaAnTich");
        //        LinkButton lblDacXa = (LinkButton)e.Item.FindControl("lblDacXa");
        //        Label txtTinhTrangGQ = (Label)e.Item.FindControl("txtTinhTrangGQ");
        //        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //        {

        //            DataRowView rv = (DataRowView)e.Item.DataItem;
        //            Decimal IDVuAnHeThong = Convert.ToDecimal(rv["IDVuAnHeThong"] + "");
        ////            Decimal TINHTRANGGQ = Convert.ToDecimal(rv["TINHTRANGGIAIQUYET"] + "");
        ////            if (!String.IsNullOrEmpty(rv["TINHTRANGGIAIQUYET"].ToString()))
        ////            {

        ////switch (TINHTRANGGQ.ToString())
        ////                {
        ////                    case "1":
        ////                        txtTinhTrangGQ.Text = "Đã thụ lý";
        ////                        break;
        ////                    case "2":
        ////                        txtTinhTrangGQ.Text = "Đã giải quyết";
        ////                        break;
        ////                    case "3":
        ////                        txtTinhTrangGQ.Text = "Đã uỷ thác thi hành án";
        ////                        break;
        ////                    default:
        ////                        break;
        ////                }


        ////            }
        //            if (!String.IsNullOrEmpty(rv["MAVUAN"].ToString()))
        //            {
        //                int MABIAN = Convert.ToInt32(rv["BiAnID"]);
        //                string MAVUAN = rv["MAVUAN"].ToString();
        //                decimal IDHETHONG = Convert.ToDecimal(rv["IDVUANHETHONG"]);
        //                THA_VUAN objTHAVuAn = null;
        //                THA_BIAN objTHABiAn = null;
        //                if (IDHETHONG != null && IDHETHONG != 0)
        //                {
        //                    objTHAVuAn = dt.THA_VUAN.Where(x => x.IDVUANHETHONG == IDHETHONG).FirstOrDefault();
        //                    if(objTHAVuAn != null)
        //                    {
        //                        objTHABiAn = dt.THA_BIAN.Where(x => x.IDBICANHETHONG == MABIAN).FirstOrDefault();                            
        //                    }
        //                }
        //                else
        //                {
        //                    objTHAVuAn = dt.THA_VUAN.Where(x => x.BA_MAVUAN == MAVUAN).FirstOrDefault();
        //                    if (objTHAVuAn != null)
        //                    {
        //                        objTHABiAn = dt.THA_BIAN.Where(x => x.ID == MABIAN).FirstOrDefault();
        //                    }
        //                }

        //                if (objTHAVuAn != null && objTHABiAn != null)
        //                {
        //                    THA_ANTICH_DON objAnTich = dt.THA_ANTICH_DON.Where(x => x.VUANID == objTHAVuAn.ID && x.BIANID == objTHABiAn.ID).FirstOrDefault();
        //                    THA_DACXA objDacXa = dt.THA_DACXA.Where(x => x.VUANID == objTHAVuAn.ID && x.BIANID == objTHABiAn.ID).FirstOrDefault();

        //                    if (objAnTich != null)
        //                    {
        //                        lblXoaAnTich.Visible = true;
        //                    }
        //                    else
        //                    {
        //                        lblXoaAnTich.Visible = false;
        //                    }
        //                    if (objDacXa != null)
        //                    {
        //                        lblDacXa.Visible = true;
        //                    }
        //                    else
        //                    {
        //                        lblDacXa.Visible = false;
        //                    }
        //                }
        //                else
        //                {
        //                    lblXoaAnTich.Visible = false; 
        //                    lblDacXa.Visible = false;

        //                }

        //            }
        //            else
        //            {
        //                lblXoaAnTich.Visible = false;
        //                lblDacXa.Visible = false;
        //            }


        //            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
        //            LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
        //            Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);


        //            LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
        //            Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
        //            if (IDVuAnHeThong > 0)
        //            {
        //                lblSua.Visible = lbtXoa.Visible = false;
        //            }
        //            else lblSua.Visible = lbtXoa.Visible = true;               
        //        }
        //        else
        //        {
        //            lblXoaAnTich.Visible = true;
        //            lblDacXa.Visible = true;
        //        }
        //    }

        //protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        //{
        //    string StrPara = "";
        //    string[] arr = null;
        //    decimal IDUser = 0;
        //    decimal bian_id = 0, vuan_id =0, IDVuAnHeThong =0;
        //    string IDVUAN = "";
        //    QT_NGUOISUDUNG oNSD = null;
        //    switch (e.CommandName)
        //    {
        //        case "sua":
        //            StrPara = e.CommandArgument.ToString();
        //            if (StrPara.Contains("$"))
        //            {
        //                arr = StrPara.Split('$');
        //                bian_id = Convert.ToDecimal(arr[0] + "");
        //                hddBiAnID.Value = bian_id.ToString();
        //                IDVuAnHeThong = Convert.ToDecimal(arr[1] + "");
        //            }
        //            if (IDVuAnHeThong > 0)
        //                Them_ThuLyBiAn(IDVuAnHeThong, bian_id);

        //            //----------Chon bi an can cap nhat thong tin----------
        //            //Lưu vào người dùng
        //            IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
        //            oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
        //            oNSD.IDTHA = Convert.ToDecimal(hddBiAnID.Value);//luu thong tin id bi an vao
        //            dt.SaveChanges();

        //            Session[ENUM_LOAIAN.AN_THA] = oNSD.IDTHA;
        //            Response.Redirect("/QLAN/THA/HoSo/ThongTinVA.aspx");
        //            break;
        //        case "ThuLyAn":
        //            StrPara = e.CommandArgument.ToString();
        //            if (StrPara.Contains("$"))
        //            {
        //                arr = StrPara.Split('$');
        //                bian_id = Convert.ToDecimal(arr[0] + "");
        //                hddBiAnID.Value = bian_id.ToString();
        //                IDVuAnHeThong = Convert.ToDecimal(arr[1] + ""); 
        //            }
        //            if (IDVuAnHeThong > 0)
        //                Them_ThuLyBiAn(IDVuAnHeThong, bian_id);

        //            //----------Chon bi an can cap nhat thong tin----------
        //            //Lưu vào người dùng
        //            IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
        //            oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
        //            oNSD.IDTHA = Convert.ToDecimal(hddBiAnID.Value);//luu thong tin id bi an vao
        //            dt.SaveChanges();

        //            Session[ENUM_LOAIAN.AN_THA] = oNSD.IDTHA;
        //            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        //            break;
        //        case "Xoa":
        //            bian_id = Convert.ToDecimal(e.CommandArgument.ToString());
        //            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
        //            if (oPer.XOA == false)
        //            {
        //                lbtthongbao.Text = "Bạn không có quyền xóa!";
        //                return;
        //            }
        //            xoa(bian_id);
        //            Resetcontrol();
        //            break;
        //        case "XoaAnTich":
        //            IDVUAN = e.CommandArgument.ToString();
        //            string StrXoaAnTich = "PopupReport('XoaAnTich/PopupXoaAnTich.aspx?IDVUAN=" + IDVUAN + "','Thi hành án, Xóa án thích',1000,700);";
        //            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrXoaAnTich, true);
        //            break;
        //        case "DacXa":
        //            IDVUAN = e.CommandArgument.ToString();
        //            string StrDacXa = "PopupReport('DacXa/PopupDacXa.aspx?IDVUAN=" + IDVUAN + "','Thi hành án, Đặc xá',1000,700);";
        //            System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrDacXa, true);
        //            break;
        //    }
        //}


        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lblXoaAnTich = (LinkButton)e.Item.FindControl("lblXoaAnTich");
                LinkButton lblDacXa = (LinkButton)e.Item.FindControl("lblDacXa");
                Label txtTinhTrangGQ = (Label)e.Item.FindControl("txtTinhTrangGQ");
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {

                    DataRowView rv = (DataRowView)e.Item.DataItem;
                    Decimal IDVuAnHeThong = Convert.ToDecimal(rv["IDVuAnHeThong"] + "");
                    if (!String.IsNullOrEmpty(rv["MAVUAN"].ToString()))
                    {
                        int MABIAN = Convert.ToInt32(rv["BiAnID"]);
                        string MAVUAN = rv["MAVUAN"].ToString();
                        decimal IDHETHONG = Convert.ToDecimal(rv["IDVUANHETHONG"]);
                        THA_VUAN objTHAVuAn = null;
                        THA_BIAN objTHABiAn = null;
                        if (IDHETHONG != null && IDHETHONG != 0)
                        {
                            objTHAVuAn = dt.THA_VUAN.Where(x => x.IDVUANHETHONG == IDHETHONG).FirstOrDefault();
                            if (objTHAVuAn != null)
                            {
                                objTHABiAn = dt.THA_BIAN.Where(x => x.IDBICANHETHONG == MABIAN).FirstOrDefault();
                            }
                        }
                        else
                        {
                            objTHAVuAn = dt.THA_VUAN.Where(x => x.BA_MAVUAN == MAVUAN).FirstOrDefault();
                            if (objTHAVuAn != null)
                            {
                                objTHABiAn = dt.THA_BIAN.Where(x => x.ID == MABIAN).FirstOrDefault();
                            }
                        }

                        if (objTHAVuAn != null && objTHABiAn != null)
                        {
                            THA_ANTICH_DON objAnTich = dt.THA_ANTICH_DON.Where(x => x.VUANID == objTHAVuAn.ID && x.BIANID == objTHABiAn.ID).FirstOrDefault();
                            THA_DACXA objDacXa = dt.THA_DACXA.Where(x => x.VUANID == objTHAVuAn.ID && x.BIANID == objTHABiAn.ID).FirstOrDefault();

                            if (objAnTich != null)
                            {
                                lblXoaAnTich.Visible = true;
                            }
                            else
                            {
                                lblXoaAnTich.Visible = false;
                            }
                            if (objDacXa != null)
                            {
                                lblDacXa.Visible = true;
                            }
                            else
                            {
                                lblDacXa.Visible = false;
                            }
                        }
                        else
                        {
                            lblXoaAnTich.Visible = false;
                            lblDacXa.Visible = false;

                        }

                    }
                    else
                    {
                        lblXoaAnTich.Visible = false;
                        lblDacXa.Visible = false;
                    }


                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                    Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);


                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                    if (IDVuAnHeThong > 0)
                    {
                        lblSua.Visible = lbtXoa.Visible = false;
                    }
                    else lblSua.Visible = lbtXoa.Visible = true;
                }
                else
                {
                    lblXoaAnTich.Visible = true;
                    lblDacXa.Visible = true;
                }
            }
        }
        protected void dgList_ItemCommand(object sender, DataGridCommandEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string StrPara = "";
                string[] arr = null;
                decimal IDUser = 0;
                decimal bian_id = 0, vuan_id = 0, IDVuAnHeThong = 0;
                string IDVUAN = "";
                QT_NGUOISUDUNG oNSD = null;
                switch (e.CommandName)
                {
                    case "sua":
                        StrPara = e.CommandArgument.ToString();
                        if (StrPara.Contains("$"))
                        {
                            arr = StrPara.Split('$');
                            bian_id = Convert.ToDecimal(arr[0] + "");
                            hddBiAnID.Value = bian_id.ToString();
                            IDVuAnHeThong = Convert.ToDecimal(arr[1] + "");
                        }
                        if (IDVuAnHeThong > 0)
                            Them_ThuLyBiAn(IDVuAnHeThong, bian_id);

                        //----------Chon bi an can cap nhat thong tin----------
                        //Lưu vào người dùng
                        IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                        oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                        oNSD.IDTHA = Convert.ToDecimal(hddBiAnID.Value);//luu thong tin id bi an vao
                        dt.SaveChanges();

                        Session[ENUM_LOAIAN.AN_THA] = oNSD.IDTHA;
                        Response.Redirect("/QLAN/THA/HoSo/ThongTinVA.aspx");
                        break;
                    case "ThuLyAn":
                        StrPara = e.CommandArgument.ToString();
                        if (StrPara.Contains("$"))
                        {
                            arr = StrPara.Split('$');
                            bian_id = Convert.ToDecimal(arr[0] + "");
                            hddBiAnID.Value = bian_id.ToString();
                            IDVuAnHeThong = Convert.ToDecimal(arr[1] + "");
                        }
                        if (IDVuAnHeThong > 0)
                            Them_ThuLyBiAn(IDVuAnHeThong, bian_id);

                        //----------Chon bi an can cap nhat thong tin----------
                        //Lưu vào người dùng
                        IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                        oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                        oNSD.IDTHA = Convert.ToDecimal(hddBiAnID.Value);//luu thong tin id bi an vao
                        dt.SaveChanges();

                        Session[ENUM_LOAIAN.AN_THA] = oNSD.IDTHA;
                        Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                        break;
                    case "Xoa":
                        bian_id = Convert.ToDecimal(e.CommandArgument.ToString());
                        MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                        if (oPer.XOA == false)
                        {
                            lbtthongbao.Text = "Bạn không có quyền xóa!";
                            return;
                        }
                        xoa(bian_id);
                        Resetcontrol();
                        break;
                    case "XoaAnTich":
                        IDVUAN = e.CommandArgument.ToString();
                        string StrXoaAnTich = "PopupReport('XoaAnTich/PopupXoaAnTich.aspx?IDVUAN=" + IDVUAN + "','Thi hành án, Xóa án thích',1000,700);";
                        System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrXoaAnTich, true);
                        break;
                    case "DacXa":
                        IDVUAN = e.CommandArgument.ToString();
                        string StrDacXa = "PopupReport('DacXa/PopupDacXa.aspx?IDVUAN=" + IDVUAN + "','Thi hành án, Đặc xá',1000,700);";
                        System.Web.UI.ScriptManager.RegisterStartupScript(this, this.GetType(), Guid.NewGuid().ToString(), StrDacXa, true);
                        break;
                }
            }
        }

        void Resetcontrol()
        {
            txtNgayBanAn.Text = "";
            txtSoBanAn.Text = "";
            txtCMND.Text = "";
            txtTenBiAn.Text = "";
            txtMaBiAn.Text = "";
            txtTenVuAn.Text = "";
            txtMaVuAn.Text = "";
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            { }
        }
        void Them_ThuLyBiAn(Decimal IDVuAnHeThong, decimal bian_id)
        {
            Boolean IsNew_VuAn = true, IsNew_BiAn = true;
            Decimal THA_VuAnID = 0;
            THA_VUAN objVA = null;
            THA_BIAN objBA = null;
            try
            {
                objVA = dt.THA_VUAN.Where(x => x.IDVUANHETHONG == IDVuAnHeThong).Single<THA_VUAN>();
                if (objVA == null)
                {
                    objVA = new THA_VUAN();
                    objBA = new THA_BIAN();
                }
                else
                {
                    IsNew_VuAn = false;
                    THA_VuAnID = objVA.ID;
                    //----------------------
                    if (objVA.ISHETHONG == 1)
                    {
                        try
                        {
                            objBA = dt.THA_BIAN.Where(x => x.VUANID == THA_VuAnID && x.IDBICANHETHONG == bian_id).Single<THA_BIAN>();
                            if (objBA != null)
                            {
                                IsNew_BiAn = false;
                                hddBiAnID.Value = objBA.ID.ToString();
                            }
                            else
                                objBA = new THA_BIAN();
                        }
                        catch (Exception ex) { objBA = new THA_BIAN(); }
                    }
                    else
                    {
                        try
                        {
                            objBA = dt.THA_BIAN.Where(x => x.ID == bian_id).Single<THA_BIAN>();
                            if (objBA != null)
                            {
                                IsNew_BiAn = false;
                                hddBiAnID.Value = objBA.ID.ToString();
                            }
                            else
                                objBA = new THA_BIAN();
                        }
                        catch (Exception ex) { objBA = new THA_BIAN(); }
                    }

                }
            }
            catch (Exception ex)
            {
                objVA = new THA_VUAN();
                objBA = new THA_BIAN();
            }
            if (IsNew_VuAn)
            {
                //Them thong tin vu an vao THA_VuAn
                objVA.IDVUANHETHONG = IDVuAnHeThong;
                THA_VuAnID = Them_VuAn_TrongHeThongQLA(IDVuAnHeThong, objVA);
            }
            //--------------------
            if (IsNew_BiAn)
            {
                //them thong tin bi an vao THA_BiAn voi VuAnID = THA_VuAnID
                objBA.VUANID = THA_VuAnID;
                objBA.IDBICANHETHONG = bian_id;
                Them_BiAn_TrongHeThongQLA(bian_id, IDVuAnHeThong, objBA);

            }
        }
        Decimal Them_VuAn_TrongHeThongQLA(decimal vuan_hethong_id, THA_VUAN objva)
        {
            AHS_VUAN_BL objBL = new AHS_VUAN_BL();
            DataTable tbl = objBL.GetThongTin(vuan_hethong_id);
            if (tbl != null && tbl.Rows.Count == 1)
            {
                DataRow row = tbl.Rows[0];
                objva.ISHETHONG = 1;
                objva.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
                objva.BA_MAVUAN = row["MAVUAN"] + "";
                objva.BA_TENVUAN = row["TENVUAN"] + "";
                objva.BA_NGAYVUAN = (String.IsNullOrEmpty(row["NgayVuAn"] + "")) ? DateTime.MinValue : Convert.ToDateTime(row["NgayVuAn"] + "");
                objva.BA_THANG = String.IsNullOrEmpty(row["NgayVuAn_Thang"] + "") ? 0 : Convert.ToDecimal(row["NgayVuAn_Thang"] + "");
                objva.BA_NAM = String.IsNullOrEmpty(row["NgayVuAn_Nam"] + "") ? 0 : Convert.ToDecimal(row["NgayVuAn_Nam"] + "");
                objva.BA_TINHCHAT = String.IsNullOrEmpty(row["TinhChatVA"] + "") ? 0 : Convert.ToDecimal(row["TinhChatVA"] + "");
                //-----------------
                objva.BA_ST_SO = row["ST_SoBanAn"] + "";
                objva.BA_ST_NGAYBANAN = (String.IsNullOrEmpty(row["ST_NgayBanAn"] + "")) ? DateTime.MinValue : Convert.ToDateTime(row["ST_NgayBanAn"] + "");
                objva.BA_ST_NGAYHIEULUC = (String.IsNullOrEmpty(row["ST_NgayHieuLuc"] + "")) ? DateTime.MinValue : Convert.ToDateTime(row["ST_NgayHieuLuc"] + "");
                objva.BA_ST_TOAANID = (String.IsNullOrEmpty(row["ST_ToaAnID"] + "")) ? 0 : Convert.ToDecimal(row["ST_ToaAnID"] + "");
                //-----------------
                objva.BA_PT_SO = row["PT_SoBanAn"] + "";
                objva.BA_PT_NGAYBANAN = (String.IsNullOrEmpty(row["PT_NgayBanAn"] + "")) ? DateTime.MinValue : Convert.ToDateTime(row["PT_NgayBanAn"] + "");
                objva.BA_PT_NGAYHIEULUC = (String.IsNullOrEmpty(row["PT_NgayHieuLuc"] + "")) ? DateTime.MinValue : Convert.ToDateTime(row["PT_NgayHieuLuc"] + "");
                objva.BA_PT_TOAANID = (String.IsNullOrEmpty(row["PT_ToaAnID"] + "")) ? 0 : Convert.ToDecimal(row["PT_ToaAnID"] + "");

                //-----------
                objva.NGAYTAO = DateTime.Now;
                objva.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                objva.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                dt.THA_VUAN.Add(objva);
                dt.SaveChanges();
                return objva.ID;
            }
            else return 0;
        }
        void Them_BiAn_TrongHeThongQLA(Decimal bian_hethong_id, decimal vuan_hethong_id, THA_BIAN objBA)
        {
            AHS_BICANBICAO obj = dt.AHS_BICANBICAO.Where(x => x.ID == bian_hethong_id).Single<AHS_BICANBICAO>();
            if (obj != null)
            {
                objBA.IDBICANHETHONG = bian_hethong_id;
                objBA.IDVUANHETHONG = vuan_hethong_id;

                objBA.BICANDAUVU = obj.BICANDAUVU;
                objBA.MABICAN = obj.MABICAN;

                objBA.HOTEN = obj.HOTEN;
                objBA.TENKHAC = obj.TENKHAC;
                objBA.NGAYSINH = (obj.NGAYSINH.HasValue && obj.NGAYSINH.Value != DateTime.MinValue) ? obj.NGAYSINH : null;
                objBA.THANGSINH = obj.THANGSINH;
                objBA.NAMSINH = obj.NAMSINH;
                objBA.SOCMND = obj.SOCMND;
                objBA.SOCCCD = obj.SO_CCCD;

                objBA.TRINHDOVANHOAID = obj.TRINHDOVANHOAID;
                objBA.NGHENGHIEPID = obj.NGHENGHIEPID;

                objBA.DANTOCID = obj.DANTOCID;
                objBA.QUOCTICHID = obj.QUOCTICHID;

                objBA.GIOITINH = obj.GIOITINH;
                objBA.TONGIAOID = obj.TONGIAOID;

                objBA.NGAYTHAMGIA = obj.NGAYTHAMGIA;

                objBA.HKTT = obj.HKTT;
                objBA.HKTT_HUYEN = obj.HKTT_HUYEN;
                objBA.KHTTCHITIET = obj.KHTTCHITIET;

                objBA.TAMTRU = obj.TAMTRU;
                objBA.TAMTRU_HUYEN = obj.TAMTRU_HUYEN;
                objBA.TAMTRUCHITIET = obj.TAMTRUCHITIET;

                objBA.CHUCVUCHINHQUYENID = obj.CHUCVUCHINHQUYENID;
                objBA.CHUCVUDANGID = obj.CHUCVUDANGID;
                objBA.TINHTRANGGIAMGIUID = obj.TINHTRANGGIAMGIUID;

                objBA.NGHIENHUT = obj.NGHIENHUT;
                objBA.TAIPHAM = obj.TAIPHAM;

                objBA.TIENAN = obj.TIENAN;
                objBA.TIENSU = obj.TIENSU;

                objBA.TREMOCOI = obj.TREMOCOI;
                objBA.BOMELYHON = obj.BOMELYHON;
                objBA.TREBOHOC = obj.TREBOHOC;
                objBA.TRELANGTHANG = obj.TRELANGTHANG;
                objBA.CONGUOIXUIGIUC = obj.CONGUOIXUIGIUC;
                objBA.NGHIENHUT = obj.NGHIENHUT;

                objBA.ISTREVITHANHNIEN = obj.ISTREVITHANHNIEN;
                objBA.LOAIDOITUONG = obj.LOAIDOITUONG;
                objBA.XACTHUC_DLDCQG = string.IsNullOrEmpty(obj.XACTHUC_DLDCQG) ? 0 : obj.XACTHUC_DLDCQG == "2" ? 3 : Convert.ToDecimal(obj.XACTHUC_DLDCQG);

                objBA.NGAYTAO = DateTime.Now;
                objBA.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                //----------------
                #region Thong tin nhan than : Bo , Me
                AHS_BICAN_NHANTHAN_BL objNT = new AHS_BICAN_NHANTHAN_BL();
                DataTable tblNT = objNT.GetByVuAn_BiAnID(vuan_hethong_id, bian_hethong_id);
                string MaMoiQH = "";
                if (tblNT != null && tblNT.Rows.Count > 0)
                {
                    foreach (DataRow item in tblNT.Rows)
                    {
                        MaMoiQH = item["MaMoiQH"] + "";
                        switch (MaMoiQH)
                        {
                            case ENUM_QH_NHANTHAN.BO:
                                objBA.HOTENBO = item["HoTen"] + "";
                                objBA.NAMSINHBO = String.IsNullOrEmpty(item["Ngaysinh_nam"] + "") ? 0 : Convert.ToDecimal(item["Ngaysinh_nam"] + "");
                                break;
                            case ENUM_QH_NHANTHAN.ME:
                                objBA.HOTENME = item["HoTen"] + "";
                                objBA.NAMSINHME = String.IsNullOrEmpty(item["Ngaysinh_nam"] + "") ? 0 : Convert.ToDecimal(item["Ngaysinh_nam"] + "");
                                break;
                        }
                    }
                }
                #endregion

                objBA.TOIDANH = "";
                objBA.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                dt.THA_BIAN.Add(objBA);
                dt.SaveChanges();
                hddBiAnID.Value = objBA.ID.ToString();

                // VNPT - Lưu Quang Huy - Thêm thông tin bản án vào THA - 23/09/2025 15h55
                // Sơ thẩm
                List<AHS_SOTHAM_BANAN_BICAO> asbbs = dt.AHS_SOTHAM_BANAN_BICAO.Where(x => x.BICAOID == bian_hethong_id).ToList();
                if (asbbs != null && asbbs.Count > 0)
                {
                    foreach (AHS_SOTHAM_BANAN_BICAO asbb in asbbs)
                    {
                        THA_SOTHAM_BANAN_BICAO tsbb = new THA_SOTHAM_BANAN_BICAO();
                        tsbb.BANANID = asbb.BANANID;
                        tsbb.VUANID = objBA.VUANID;
                        tsbb.BICAOID = objBA.ID;
                        tsbb.ISTHAMGIAPHIENTOA = asbb.ISTHAMGIAPHIENTOA;
                        tsbb.ANPHI = asbb.ANPHI;
                        tsbb.ISDINHCHI = asbb.ISDINHCHI;
                        tsbb.NGAYNHANBANAN = asbb.NGAYNHANBANAN;
                        tsbb.TOA_GIAIQUYET_ID = asbb.TOA_GIAIQUYET_ID;
                        DataExtensions.Insert<THA_SOTHAM_BANAN_BICAO>(tsbb);
                    }
                }
                List<AHS_SOTHAM_BANAN_DIEU_TONGHOP> asbdts = dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Where(x => x.BICANID == bian_hethong_id).ToList();
                if (asbdts != null && asbdts.Count > 0)
                {
                    foreach (AHS_SOTHAM_BANAN_DIEU_TONGHOP asbdt in asbdts)
                    {
                        THA_SOTHAM_BANAN_DIEU_TONGHOP tsbdt = new THA_SOTHAM_BANAN_DIEU_TONGHOP();
                        tsbdt.BANANID = asbdt.BANANID;
                        tsbdt.BICANID = objBA.ID;
                        tsbdt.VUANID = objBA.VUANID;
                        tsbdt.HINHPHATID = asbdt.HINHPHATID;
                        tsbdt.LOAIHINHPHAT = asbdt.LOAIHINHPHAT;
                        tsbdt.TF_VALUE = asbdt.TF_VALUE;
                        tsbdt.SH_VALUE = asbdt.SH_VALUE;

                        tsbdt.TG_NAM = asbdt.TG_NAM;
                        tsbdt.TG_THANG = asbdt.TG_THANG;
                        tsbdt.TG_NGAY = asbdt.TG_NGAY;
                        tsbdt.K_VALUE1 = asbdt.K_VALUE1;

                        tsbdt.K_VALUE2 = asbdt.K_VALUE2;
                        tsbdt.ISANTREO = asbdt.ISANTREO;
                        tsbdt.TGTT_NAM = asbdt.TGTT_NAM;
                        tsbdt.TGTT_THANG = asbdt.TGTT_THANG;

                        tsbdt.TGTT_NGAY = asbdt.TGTT_NGAY;
                        tsbdt.TENTOIDANH = asbdt.TENTOIDANH;
                        tsbdt.ISMAIN = asbdt.ISMAIN;
                        DataExtensions.Insert<THA_SOTHAM_BANAN_DIEU_TONGHOP>(tsbdt);
                    }
                }

                List<AHS_SOTHAM_BANAN_DIEU_CHITIET> asbdcs = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == bian_hethong_id && x.VUANID == vuan_hethong_id).ToList();
                if (asbdcs != null && asbdcs.Count > 0)
                {
                    foreach (AHS_SOTHAM_BANAN_DIEU_CHITIET asbdc in asbdcs)
                    {
                        THA_SOTHAM_BANAN_DIEU_CHITIET tsbdc = new THA_SOTHAM_BANAN_DIEU_CHITIET();
                        tsbdc.BANANID = asbdc.BANANID;
                        tsbdc.BICANID = objBA.ID;
                        tsbdc.VUANID = objBA.VUANID;
                        tsbdc.DIEULUATID = asbdc.DIEULUATID;
                        tsbdc.HINHPHATID = asbdc.HINHPHATID;
                        tsbdc.LOAIHINHPHAT = asbdc.LOAIHINHPHAT;
                        tsbdc.TF_VALUE = asbdc.TF_VALUE;
                        tsbdc.SH_VALUE = asbdc.SH_VALUE;
                        tsbdc.TG_NAM = asbdc.TG_NAM;
                        tsbdc.TG_THANG = asbdc.TG_THANG;
                        tsbdc.TG_NGAY = asbdc.TG_NGAY;
                        tsbdc.K_VALUE1 = asbdc.K_VALUE1;
                        tsbdc.K_VALUE2 = asbdc.K_VALUE2;
                        tsbdc.ISANTREO = asbdc.ISANTREO;
                        tsbdc.TOIDANHID = asbdc.TOIDANHID;
                        tsbdc.ISCHANGE = asbdc.ISCHANGE;
                        tsbdc.TGTT_NAM = asbdc.TGTT_NAM;
                        tsbdc.TGTT_THANG = asbdc.TGTT_THANG;
                        tsbdc.TGTT_NGAY = asbdc.TGTT_NGAY;
                        tsbdc.TENTOIDANH = asbdc.TENTOIDANH;
                        tsbdc.ISMAIN = asbdc.ISMAIN;
                        DataExtensions.Insert<THA_SOTHAM_BANAN_DIEU_CHITIET>(tsbdc);
                    }
                }

                List<AHS_TONGHOPHINHPHAT> ats = DataExtensions.GetAllWithClause<AHS_TONGHOPHINHPHAT>($"VUANID = {vuan_hethong_id} AND BICAOID = {bian_hethong_id}");
                if (ats != null && ats.Count > 0)
                {
                    foreach (AHS_TONGHOPHINHPHAT at in ats)
                    {
                        THA_TONGHOPHINHPHAT tt = new THA_TONGHOPHINHPHAT();
                        tt.TOAANID_ST = at.TOAANID_ST;
                        tt.TOAANID_PT = at.TOAANID_PT;
                        tt.VUANID = objBA.VUANID;
                        tt.BICAOID = objBA.ID;
                        tt.TENTOIDANH_ST = at.TENTOIDANH_ST;
                        tt.TENTOIDANH_PT = at.TENTOIDANH_PT;
                        tt.HINHPHAT_ST = at.HINHPHAT_ST;
                        tt.HINHPHAT_PT = at.HINHPHAT_PT;
                        tt.TONGHOPHINHPHAT = at.TONGHOPHINHPHAT;
                        tt.HP_TANGGIAM = at.HP_TANGGIAM;
                        tt.NGAYSUA = at.NGAYSUA;
                        tt.NGUOISUA = at.NGUOISUA;
                        tt.NGAYTAO = at.NGAYTAO;
                        tt.NGUOITAO = at.NGUOITAO;
                        DataExtensions.Insert<THA_TONGHOPHINHPHAT>(tt);
                    }
                }

                // phúc thẩm
                List<AHS_PHUCTHAM_BANAN_BICAO> apbbs = dt.AHS_PHUCTHAM_BANAN_BICAO.Where(x => x.BICAOID == bian_hethong_id).ToList();
                if (apbbs != null && apbbs.Count > 0)
                {
                    foreach (AHS_PHUCTHAM_BANAN_BICAO apbb in apbbs)
                    {
                        THA_PHUCTHAM_BANAN_BICAO tpbb = new THA_PHUCTHAM_BANAN_BICAO();
                        tpbb.BANANID = apbb.BANANID;
                        tpbb.VUANID = objBA.VUANID;
                        tpbb.BICAOID = objBA.ID;
                        tpbb.ISTHAMGIAPHIENTOA = apbb.ISTHAMGIAPHIENTOA;
                        tpbb.ANPHI = apbb.ANPHI;
                        tpbb.ISDINHCHI = apbb.ISDINHCHI;
                        tpbb.NGAYNHANBANAN = apbb.NGAYNHANBANAN;
                        tpbb.TOA_GIAIQUYET_ID = apbb.TOA_GIAIQUYET_ID;
                        DataExtensions.Insert<THA_PHUCTHAM_BANAN_BICAO>(tpbb);
                    }
                }

                List<AHS_PHUCTHAM_BANAN_DIEU_CT> apbdcs = dt.AHS_PHUCTHAM_BANAN_DIEU_CT.Where(x => x.BICANID == bian_hethong_id).ToList();
                if (apbdcs != null && apbdcs.Count > 0)
                {
                    foreach (AHS_PHUCTHAM_BANAN_DIEU_CT apbdc in apbdcs)
                    {
                        THA_PHUCTHAM_BANAN_DIEU_CT tpbdc = new THA_PHUCTHAM_BANAN_DIEU_CT();
                        tpbdc.BANANID = apbdc.BANANID;
                        tpbdc.BICANID = objBA.ID;
                        tpbdc.VUANID = objBA.VUANID;
                        tpbdc.DIEULUATID = apbdc.DIEULUATID;
                        tpbdc.HINHPHATID = apbdc.HINHPHATID;
                        tpbdc.LOAIHINHPHAT = apbdc.LOAIHINHPHAT;
                        tpbdc.TF_VALUE = apbdc.TF_VALUE;
                        tpbdc.SH_VALUE = apbdc.SH_VALUE;
                        tpbdc.TG_NAM = apbdc.TG_NAM;
                        tpbdc.TG_THANG = apbdc.TG_THANG;
                        tpbdc.TG_NGAY = apbdc.TG_NGAY;
                        tpbdc.K_VALUE1 = apbdc.K_VALUE1;
                        tpbdc.K_VALUE2 = apbdc.K_VALUE2;
                        tpbdc.ISANTREO = apbdc.ISANTREO;
                        tpbdc.TOIDANHID = apbdc.TOIDANHID;
                        tpbdc.ISCHANGE = apbdc.ISCHANGE;
                        tpbdc.TGTT_NAM = apbdc.TGTT_NAM;
                        tpbdc.TGTT_THANG = apbdc.TGTT_THANG;
                        tpbdc.TGTT_NGAY = apbdc.TGTT_NGAY;
                        tpbdc.TENTOIDANH = apbdc.TENTOIDANH;
                        tpbdc.ISMAIN = apbdc.ISMAIN;
                        DataExtensions.Insert<THA_PHUCTHAM_BANAN_DIEU_CT>(tpbdc);
                    }
                }
                // VNPT - Lưu Quang Huy - Thêm thông tin bản án vào THA - 23/09/2025 15h55

                THA_SOTHAM_CAOTRANG_DIEULUAT tha_caotrang_dieuluat = new THA_SOTHAM_CAOTRANG_DIEULUAT();
                List<AHS_SOTHAM_CAOTRANG_DIEULUAT> ahs_caotrang_dieuluat = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == bian_hethong_id && x.VUANID == vuan_hethong_id).ToList();
                if (ahs_caotrang_dieuluat != null)
                {
                    foreach (AHS_SOTHAM_CAOTRANG_DIEULUAT dr in ahs_caotrang_dieuluat)
                    {
                        tha_caotrang_dieuluat.BICANID = objBA.ID;
                        tha_caotrang_dieuluat.CAOTRANGID = dr.CAOTRANGID;
                        tha_caotrang_dieuluat.DIEULUATID = dr.DIEULUATID;
                        tha_caotrang_dieuluat.ISMAIN = dr.ISMAIN;
                        tha_caotrang_dieuluat.NGAYTAO = DateTime.Now;
                        tha_caotrang_dieuluat.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        tha_caotrang_dieuluat.TENTOIDANH = dr.TENTOIDANH;
                        tha_caotrang_dieuluat.TOIDANHID = dr.TOIDANHID;
                        tha_caotrang_dieuluat.VUANID = objBA.VUANID;
                        tha_caotrang_dieuluat.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);

                        dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Add(tha_caotrang_dieuluat);
                        dt.SaveChanges();
                    }
                    //objBA.TOIDANH = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == bian_hethong_id && x.VUANID == vuan_hethong_id && x.ISMAIN==1).First().TENTOIDANH;
                    //dt.SaveChanges();
                }
            }
        }


        //----------------------------------------------------
        public void xoa(decimal id)
        {
            THA_BIAN oT = dt.THA_BIAN.Where(x => x.ID == id).FirstOrDefault();
            if (oT != null)
            {
                dt.THA_BIAN.Remove(oT);
                dt.SaveChanges();

                hddPageIndex.Value = "1";
                LoadGrid();
                Resetcontrol();
                lbtthongbao.Text = "Xóa thành công!";
            }
            else
            {
                hddPageIndex.Value = "1";
                LoadGrid();
                Resetcontrol();
            }

        }




        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                //lbthongbao.Text = ex.Message; 
            }
        }

        protected void dropLoaiLuaChon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                dropTinhTrangGQ.SelectedIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            txtNgayBanAn.Text = "";
            txtSoBanAn.Text = "";
            txtCMND.Text = "";
            txtTenBiAn.Text = "";
            txtMaBiAn.Text = "";
            txtTenVuAn.Text = "";
            txtMaVuAn.Text = "";
            dropTinhTrangGQ.SelectedIndex = 0;
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            { }
        }

        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            Response.Redirect("/QLAN/THA/HoSo/ThongTinVA.aspx");
        }


        string TemplateWordSTPT = ConfigurationManager.AppSettings["TemplateWordSTPT"];
        protected void cmdInDanhsach_Click(object sender, EventArgs e)
        {
            try
            {
                lbtthongbao.Text = "";
                int page_size = Convert.ToInt32(ddlPageCount.SelectedValue);
                int pageindex = Convert.ToInt32(hddPageIndex.Value);

                string mavuan = txtMaVuAn.Text.Trim();
                string tenvuan = txtTenVuAn.Text.Trim();
                string mabian = txtMaBiAn.Text.Trim();
                string tenbian = txtTenBiAn.Text.Trim();
                string sobanan = txtSoBanAn.Text.Trim();
                DateTime ngaybanan = (string.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                int loai = Convert.ToInt32(dropLoaiLuaChon.SelectedValue);
                int tinhtrangGQ = Convert.ToInt32(dropTinhTrangGQ.SelectedValue);
                int TRANGTHAIGQ = bian_QDTHA.Checked ? 1 : 0;
                //int trangthai_thuly_tha = Convert.ToDecimal(dropTrangThaiThuLyTHA.SelectedValue);
                THA_BIAN_BL objBL = new THA_BIAN_BL();
                DataTable tbl = null;
                AHS_TONGHOPHINHPHAT ahs_tonghop = new AHS_TONGHOPHINHPHAT();
                if (loai == 1)
                {
                    tbl = objBL.GetAnHSTrongHeThong(ToaAnID, mabian, tenbian, mavuan, tenvuan, sobanan, ngaybanan, tinhtrangGQ, TRANGTHAIGQ, txtCMND.Text.Trim(), txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), 1, int.MaxValue);
                    foreach (DataRow row in tbl.Rows)
                    {
                        if (row["MAGIAIDOAN"] + "" == "2")
                        {
                            row["HINHPHAT_TONGHOP"] = ahs_tonghop.Tonghophinhphat_ST((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);
                        }
                        else
                        {
                            row["HINHPHAT_TONGHOP"] = ahs_tonghop.Tonghophinhphat_PT((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);
                        }
                    }
                }
                else
                {
                    tbl = objBL.GetAnHSNgoaiHeThong(ToaAnID, mabian, tenbian, mavuan, tenvuan, sobanan, ngaybanan, tinhtrangGQ, TRANGTHAIGQ, txtCMND.Text.Trim(), txtTuNgay.Text.Trim(), txtDenNgay.Text.Trim(), 1, int.MaxValue);
                    foreach (DataRow row in tbl.Rows)
                    {
                        if (row["VUANIDOLD"] + "" != "" && row["BIANIDOLD"] + "" != "")
                        {
                            if (row["MAGIAIDOAN"] + "" == "2")
                            {
                                row["HINHPHAT_TONGHOP"] = ahs_tonghop.Tonghophinhphat_ST((decimal)row["VUANIDOLD"], (decimal)row["BIANIDOLD"]);
                            }
                            else
                            {
                                row["HINHPHAT_TONGHOP"] = ahs_tonghop.Tonghophinhphat_PT((decimal)row["IDVuAnHeThong"], (decimal)row["BIANID"]);
                            }
                        }
                    }
                }
                string saveAs = TemplateWordSTPT + "rptDS_THA.xlsx";
                string fileNameSave = "Danhsachbian.xlsx";

                //Đường dẫn vào thư mục file Template.
                string dataDir = TemplateWordSTPT + "rptDanhsachbianTHA.xlsx";

                //Open Template
                FileStream fstream = new FileStream(dataDir, FileMode.Open);
                Workbook workbook = new Workbook(fstream);
                Worksheet worksheet = workbook.Worksheets["Danhsachbian"];

                try
                {
                    if (tbl != null && tbl.Rows.Count > 0)
                    {
                        //Insert công thức tính tổng các dòng vào cột C
                        decimal rowcount = 2; //Dòng đầu tiên

                        foreach (DataRow row in tbl.Rows)
                        {
                            if (Convert.ToDecimal(row["STT"] + " ") != 0 || (row["STT"] + "") != "") worksheet.Cells['A' + Convert.ToString(rowcount)].Value = Convert.ToDecimal(row["STT"] + "");
                            if ((row["HOTENBIAN_TOIDANH"] + "") != "") worksheet.Cells['B' + Convert.ToString(rowcount)].Value = row["HOTENBIAN_TOIDANH"];
                            if ((row["TenVuAn"] + "") != "") worksheet.Cells['C' + Convert.ToString(rowcount)].Value = row["TenVuAn"] + "";
                            if ((row["SOBANAN_QD"] + "") != "") worksheet.Cells['D' + Convert.ToString(rowcount)].Value = (row["SOBANAN_QD"] + "");
                            if ((row["NGAYBANAN_QD"] + "") != "") worksheet.Cells['E' + Convert.ToString(rowcount)].Value = ((DateTime)row["NGAYBANAN_QD"]).ToString("dd/MM/yyyy", cul);
                            if ((row["HINHPHAT_TONGHOP"] + "") != "") worksheet.Cells['F' + Convert.ToString(rowcount)].Value = row["HINHPHAT_TONGHOP"] + "";
                            if ((row["THA_SOTHULY_NGAYTHULY"] + "") != "") worksheet.Cells['G' + Convert.ToString(rowcount)].Value = row["THA_SOTHULY_NGAYTHULY"] + "";
                            if ((row["THA_QD_SO"] + "") != "") worksheet.Cells['H' + Convert.ToString(rowcount)].Value = row["THA_QD_SO"] + "";
                            if ((row["TINHTRANGGQ"] + "") != "") worksheet.Cells['I' + Convert.ToString(rowcount)].Value = row["TINHTRANGGQ"] + "";

                            rowcount++;
                        }

                        // Accessing the "A1" cell from the worksheet
                        Cell cell = worksheet.Cells["A" + (rowcount)];

                        // Setting the horizontal alignment of the text in the "A1" cell
                        Aspose.Cells.Style style = new Aspose.Cells.Style();
                        style.HorizontalAlignment = TextAlignmentType.Center;
                        style.VerticalAlignment = TextAlignmentType.Center;
                        style.Font.Name = "Times New Roman";
                        style.Font.Size = 13;
                        style.Font.IsBold = true;

                        cell.SetStyle(style);

                        //set inner boder of range
                        Aspose.Cells.Style stl = workbook.Styles[workbook.Styles.Add()];
                        stl.Borders[Aspose.Cells.BorderType.TopBorder].LineStyle = CellBorderType.Thin;
                        stl.Borders[Aspose.Cells.BorderType.TopBorder].Color = System.Drawing.Color.Black;
                        stl.Borders[Aspose.Cells.BorderType.LeftBorder].LineStyle = CellBorderType.Thin;
                        stl.Borders[Aspose.Cells.BorderType.LeftBorder].Color = System.Drawing.Color.Black;
                        stl.Borders[Aspose.Cells.BorderType.BottomBorder].LineStyle = CellBorderType.Thin;
                        stl.Borders[Aspose.Cells.BorderType.BottomBorder].Color = System.Drawing.Color.Black;
                        stl.Borders[Aspose.Cells.BorderType.RightBorder].LineStyle = CellBorderType.Thin;
                        stl.Borders[Aspose.Cells.BorderType.RightBorder].Color = System.Drawing.Color.Black;

                        //Save the target book file.
                        workbook.Save(saveAs);

                        ExportData(fileNameSave, (string)saveAs);

                    }
                }
                catch (Exception ex)
                {
                    lbtthongbao.Text = ex.Message;
                    fstream.Close();
                }
                finally
                {
                    fstream.Close();
                }
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
            }
        }

        protected void ExportData(string fileName, string path)
        {
            try
            {
                //copy to MemoryStream
                MemoryStream ms = new MemoryStream();
                using (FileStream fs = File.OpenRead(Path.Combine(path)))
                {
                    fs.CopyTo(ms);
                }

                //Delete file
                if (File.Exists(Path.Combine(path)))
                    File.Delete(Path.Combine(path));

                //Download file
                fileName = fileName.Replace(".xlsx", "");
                var cacheKey = Guid.NewGuid().ToString("N");
                Context.Cache.Insert(key: cacheKey, value: ms.ToArray(), dependencies: null, absoluteExpiration: DateTime.Now.AddSeconds(30), slidingExpiration: System.Web.Caching.Cache.NoSlidingExpiration);
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Download", "window.location='" + Cls_Comon.GetRootURL_HTTPS_CONFIG() + "/DownloadFile.aspx?cacheKey=" + cacheKey + "&FileName=" + fileName + "&Extension=" + ".xlsx" + "';", true);

                //Response.Clear();
                //Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                //Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
                //Response.BinaryWrite(ms.ToArray());
            }
            catch (Exception ex)
            {
                lbtthongbao.Text = ex.Message;
                return;
            }
            finally
            {
                //Response.End();
            }

        }
    }
}