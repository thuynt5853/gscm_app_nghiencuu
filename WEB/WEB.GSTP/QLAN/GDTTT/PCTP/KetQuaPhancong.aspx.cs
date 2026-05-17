using BL.GSTP;
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
using WEB.GSTP.QLAN.GDTTT.In;

namespace WEB.GSTP.QLAN.GDTTT.PCTP
{
    public partial class KetQuaPhancong : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {  //Load Toa an
                DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
                DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
                ddlToaXetXu.DataSource = dtTA;
                ddlToaXetXu.DataTextField = "MA_TEN";
                ddlToaXetXu.DataValueField = "ID";
                ddlToaXetXu.DataBind();
                ddlToaXetXu.Items.Insert(0, new ListItem("--- Chọn --- ", "0"));
                //Load Thẩm phán
                DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
                GDTTT_DON_BL oGDTBL = new GDTTT_DON_BL();
                DataTable oCBDT = oGDTBL.CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                ddlThamphan.DataSource = oCBDT;
                ddlThamphan.DataTextField = "HOTEN";
                ddlThamphan.DataValueField = "ID";
                ddlThamphan.DataBind();
                ddlThamphan.Items.Insert(0, new ListItem("--- Tất cả ---", "0"));

                LoadGrid();
            }
        }

        public void LoadGrid()
        {
            DataTable oDT = getDS();

            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            #endregion
            dgList.DataSource = oDT;
            dgList.DataBind();

        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }

        #endregion
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    DataRowView rv = (DataRowView)e.Item.DataItem;
                    Decimal check_tp = Convert.ToDecimal(rv["CHECK_VUAN"]);
                    ImageButton cmdXoa = (ImageButton)e.Item.FindControl("cmdXoa");
                    if (check_tp > 0)
                    {
                        //chk.ToolTip = "Vụ án đang giải quyết, để nghi sang phần <4.Thay đổi Thẩm phán giải quyết> để thay đổi Thẩm phán!";
                        e.Item.ToolTip = "Không được hủy kết quả phân công khi Vụ án đang giải quyết!";
                        cmdXoa.Visible = false;
                    }
                }
            }
            catch (Exception ex) { }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            GDTTT_DON_BL oPCBL = new GDTTT_DON_BL();
            // Lấy giá trị CommandArgument
            string[] args = e.CommandArgument.ToString().Split(',');

            // Lấy từng phần;
            decimal KQ_id = Convert.ToDecimal(args[0]);
            decimal vHinhThucPC = Convert.ToDecimal(args[1]);
            string vLoai = args[2];
            string strMsg = string.Empty;

            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            switch (e.CommandName)
            {
                case "Sua":
                    if (vLoai == "VUANKN")
                        if (vHinhThucPC == 0) //phân công ngẫu nhiên
                        {
                            //kiểm tra vụ án đã chuyển TP chưa, nếu chuyển r thì không được sửa phân công
                            if (oPCBL.CHECK_VAKN_CHUYENTP_XOA_PHANCONG_NGAUNHIEN(KQ_id))
                                strMsg = "Có vụ án đã được chuyển thẩm phán tối cao, bạn sẽ không được phép sửa kết quả phân công!";
                        }
                        else
                        {
                            //kiểm tra vụ án đã chuyển TP chưa, nếu chuyển r thì không được sửa phân công
                            if (oPCBL.CHECK_VAKN_CHUYENTP_XOA_PHANCONG_CHIDINH(KQ_id))
                                strMsg = "Có vụ án đã được chuyển thẩm phán tối cao, bạn sẽ không được phép sửa kết quả phân công!";
                        }

                    if (!string.IsNullOrEmpty(strMsg))
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);
                    else
                        Response.Redirect("CapnhatKetqua.aspx?kqid=" + KQ_id.ToString() + "&hinhthuc=" + vHinhThucPC + "&type=" + vLoai);

                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lblThongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    if (vLoai == "DON")
                    {
                        if (vHinhThucPC == 0) //phân công ngẫu nhiên
                        {
                            //kiểm tra đơn đã có SoTT, TBTP thì không được xóa phân công
                            if (oPCBL.CHECK_DON_XOA_PHANCONG_NGAUNHIEN(KQ_id))
                                strMsg = "Một số đơn đã được thêm Số tờ trình hoặc Thông báo phân công thẩm phán sẽ không được phép xóa kết quả phân công!";
                            else
                            {
                                foreach (GDTTT_PCTP_CHITIET kq in dt.GDTTT_PCTP_CHITIET.Where(x => x.KETQUAID == KQ_id).ToList())
                                {
                                    GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == kq.DONID).FirstOrDefault();
                                    if (oDon != null)
                                    {
                                        oDon.THAMPHANID = 0;
                                        oDon.ISCHIDINH = 0;
                                    }
                                    dt.GDTTT_PCTP_CHITIET.Remove(kq);
                                    dt.SaveChanges();
                                }

                                GDTTT_PCTP_KETQUA okq = dt.GDTTT_PCTP_KETQUA.Where(x => x.ID == KQ_id).FirstOrDefault();
                                if (okq != null)
                                {
                                    dt.GDTTT_PCTP_KETQUA.Remove(okq);
                                    dt.SaveChanges();
                                }
                                LoadGrid();
                            }
                        }
                        else
                        {
                            //kiểm tra đơn đã có SoTT, TBTP thì không được xóa phân công
                            if (oPCBL.CHECK_DON_XOA_PHANCONG_CHIDINH(KQ_id))
                                strMsg = "Một số đơn đã được thêm Số tờ trình hoặc Thông báo phân công thẩm phán sẽ không được phép xóa kết quả phân công!";
                            else
                            {
                                foreach (GDTTT_PCTP_CHITIET_CHIDINH kq in dt.GDTTT_PCTP_CHITIET_CHIDINH.Where(x => x.KETQUAID == KQ_id).ToList())
                                {
                                    GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == kq.DONID).FirstOrDefault();
                                    if (oDon != null)
                                    {
                                        oDon.THAMPHANID = 0;
                                        oDon.ISCHIDINH = 0;// xóa kết quả phân công chỉ định thì đơn thành phân công ngẫu nhiên
                                    }
                                    dt.GDTTT_PCTP_CHITIET_CHIDINH.Remove(kq);
                                    dt.SaveChanges();
                                }

                                GDTTT_PCTP_KETQUA_CHIDINH okq = dt.GDTTT_PCTP_KETQUA_CHIDINH.Where(x => x.ID == KQ_id).FirstOrDefault();
                                if (okq != null)
                                {
                                    dt.GDTTT_PCTP_KETQUA_CHIDINH.Remove(okq);
                                    dt.SaveChanges();
                                }
                                LoadGrid();
                            }
                        }
                    }
                    else if (vLoai == "VUANKN")
                    {
                        if (vHinhThucPC == 0) //phân công ngẫu nhiên
                        {
                            //kiểm tra vụ án đã chuyển TP chưa, nếu chuyển r thì không được xóa phân công
                            if (oPCBL.CHECK_VAKN_CHUYENTP_XOA_PHANCONG_NGAUNHIEN(KQ_id))
                                strMsg = "Có vụ án đã được chuyển thẩm phán tối cao, bạn sẽ không được phép xóa kết quả phân công!";
                            //kiểm tra đơn đã có SoTT, TBTP thì không được xóa phân công
                            else if (oPCBL.CHECK_VAKN_XOA_PHANCONG_NGAUNHIEN(KQ_id))
                                strMsg = "Có vụ án đã được thêm Số tờ trình hoặc Thông báo phân công thẩm phán sẽ không được phép xóa kết quả phân công!";
                            else
                            {
                                foreach (GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET kq in dt.GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET.Where(x => x.NGAUNHIENID == KQ_id).ToList())
                                {
                                    GDTTT_VUAN_CHITIET_CHUYEN oVu = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == kq.VUANID).FirstOrDefault();
                                    if (oVu != null)
                                    {
                                        oVu.THAMPHANID = null;
                                        oVu.TRANGTHAICHUYENTP = 0;
                                        oVu.NGAYCHUYENTP = null;
                                    }
                                    dt.GDTTT_PCTP_VAKN_NGAUNHIEN_CHITIET.Remove(kq);
                                    dt.SaveChanges();
                                }

                                GDTTT_PCTP_VAKN_NGAUNHIEN okq = dt.GDTTT_PCTP_VAKN_NGAUNHIEN.Where(x => x.ID == KQ_id).FirstOrDefault();
                                if (okq != null)
                                {
                                    dt.GDTTT_PCTP_VAKN_NGAUNHIEN.Remove(okq);
                                    dt.SaveChanges();
                                }
                                LoadGrid();
                            }
                        }
                        else //phân công chỉ định
                        {
                            //kiểm tra vụ án đã chuyển TP chưa, nếu chuyển r thì không được xóa phân công
                            if (oPCBL.CHECK_VAKN_CHUYENTP_XOA_PHANCONG_CHIDINH(KQ_id))
                                strMsg = "Có vụ án đã được chuyển thẩm phán tối cao, bạn sẽ không được phép xóa kết quả phân công!";
                            //kiểm tra đơn đã có SoTT, TBTP thì không được xóa phân công
                            else if (oPCBL.CHECK_VAKN_XOA_PHANCONG_CHIDINH(KQ_id))
                                strMsg = "Có vụ án đã được thêm Số tờ trình hoặc Thông báo phân công thẩm phán sẽ không được phép xóa kết quả phân công!";
                            else
                            {
                                foreach (GDTTT_PCTP_VAKN_CHIDINH_CHITIET kq in dt.GDTTT_PCTP_VAKN_CHIDINH_CHITIET.Where(x => x.CHIDINHID == KQ_id).ToList())
                                {
                                    GDTTT_VUAN_CHITIET_CHUYEN oVu = dt.GDTTT_VUAN_CHITIET_CHUYEN.Where(x => x.VUANID == kq.VUANID).FirstOrDefault();
                                    if (oVu != null)
                                    {
                                        oVu.THAMPHANID = null;
                                        oVu.TRANGTHAICHUYENTP = 0;
                                        oVu.NGAYCHUYENTP = null;
                                    }
                                    dt.GDTTT_PCTP_VAKN_CHIDINH_CHITIET.Remove(kq);
                                    dt.SaveChanges();
                                }

                                GDTTT_PCTP_VAKN_CHIDINH okq = dt.GDTTT_PCTP_VAKN_CHIDINH.Where(x => x.ID == KQ_id).FirstOrDefault();
                                if (okq != null)
                                {
                                    dt.GDTTT_PCTP_VAKN_CHIDINH.Remove(okq);
                                    dt.SaveChanges();
                                }
                                LoadGrid();
                            }
                        }
                    }

                    if (!string.IsNullOrEmpty(strMsg))
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + strMsg + "');", true);

                    break;
                case "In":
                    Session["GDTTT_MABM"] = "PHANCONG_KETQUA";
                    #region "Thông tin kết quả"
                    DTGDTTT objds = new DTGDTTT();
                    DataTable oDT = new DataTable();

                    //lấy kết quả hình thức phân công ngẫu nhiên
                    if (vHinhThucPC == 0)
                    {
                        if (vLoai == "DON")
                        {
                            GDTTT_PCTP_KETQUA k = dt.GDTTT_PCTP_KETQUA.Where(x => x.ID == KQ_id).FirstOrDefault();
                            DTGDTTT.DT_PHANCONG_KETQUARow rk = objds.DT_PHANCONG_KETQUA.NewDT_PHANCONG_KETQUARow();
                            rk.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                            rk.TUNGAY = ((DateTime)k.TUNGAY).ToString("dd/MM/yyyy");
                            rk.DENNGAY = ((DateTime)k.DENNGAY).ToString("dd/MM/yyyy");
                            rk.NGAYTHUCHIEN = ((DateTime)k.NGAYPHANCONG).ToString("dd/MM/yyyy HH:MM");
                            try
                            {
                                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == k.NGUOITHUCHIENID).FirstOrDefault();
                                if (oNSD != null)
                                {
                                    DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oNSD.CANBOID).FirstOrDefault();
                                    if (oCB != null) rk.NGUOITHUCHIEN = oCB.HOTEN;
                                }
                            }
                            catch (Exception ex) { }

                            objds.DT_PHANCONG_KETQUA.AddDT_PHANCONG_KETQUARow(rk);
                            objds.AcceptChanges();
                            oDT = oPCBL.DON_GETTHEOKETQUAID(ToaAnID, KQ_id, 0, "", "", "", "", "", 0); //lấy kết quả hình thức phân công đơn ngẫu nhiên
                        }
                        else if (vLoai == "VUANKN")
                        {
                            GDTTT_PCTP_VAKN_NGAUNHIEN k = dt.GDTTT_PCTP_VAKN_NGAUNHIEN.Where(x => x.ID == KQ_id).FirstOrDefault();
                            DTGDTTT.DT_PHANCONG_KETQUARow rk = objds.DT_PHANCONG_KETQUA.NewDT_PHANCONG_KETQUARow();
                            rk.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                            rk.TUNGAY = ((DateTime)k.TUNGAY).ToString("dd/MM/yyyy");
                            rk.DENNGAY = ((DateTime)k.DENNGAY).ToString("dd/MM/yyyy");
                            rk.NGAYTHUCHIEN = ((DateTime)k.NGAYPHANCONG).ToString("dd/MM/yyyy HH:MM");
                            try
                            {
                                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == k.NGUOITHUCHIENID).FirstOrDefault();
                                if (oNSD != null)
                                {
                                    DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oNSD.CANBOID).FirstOrDefault();
                                    if (oCB != null) rk.NGUOITHUCHIEN = oCB.HOTEN;
                                }
                            }
                            catch (Exception ex) { }

                            objds.DT_PHANCONG_KETQUA.AddDT_PHANCONG_KETQUARow(rk);
                            objds.AcceptChanges();
                            oDT = oPCBL.GET_THEOKETQUAID_PHANCONGNGAUNHIEN_VAKN(ToaAnID, KQ_id, 0, "", "", "", "", "", 0); //lấy kết quả hình thức phân công vụ án kháng nghị ngẫu nhiên
                        }
                        Session["PHANCONG_KETQUA_HINH_THUC"] = "NGAU_NHIEN";
                    }
                    else
                    {
                        if (vLoai == "DON")
                        {
                            GDTTT_PCTP_KETQUA_CHIDINH k = dt.GDTTT_PCTP_KETQUA_CHIDINH.Where(x => x.ID == KQ_id).FirstOrDefault();
                            DTGDTTT.DT_PHANCONG_KETQUARow rk = objds.DT_PHANCONG_KETQUA.NewDT_PHANCONG_KETQUARow();
                            rk.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                            rk.TUNGAY = ((DateTime)k.TUNGAY).ToString("dd/MM/yyyy");
                            rk.DENNGAY = ((DateTime)k.DENNGAY).ToString("dd/MM/yyyy");
                            rk.NGAYTHUCHIEN = ((DateTime)k.NGAYPHANCONG).ToString("dd/MM/yyyy HH:MM");
                            try
                            {
                                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == k.NGUOITHUCHIENID).FirstOrDefault();
                                if (oNSD != null)
                                {
                                    DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oNSD.CANBOID).FirstOrDefault();
                                    if (oCB != null) rk.NGUOITHUCHIEN = oCB.HOTEN;
                                }
                            }
                            catch (Exception ex) { }

                            objds.DT_PHANCONG_KETQUA.AddDT_PHANCONG_KETQUARow(rk);
                            objds.AcceptChanges();
                            oDT = oPCBL.DON_GETTHEOKETQUAID_CHIDINH(ToaAnID, KQ_id, 0, "", "", "", "", "", 0, null); //lấy kết quả hình thức phân công đơn chỉ định
                        }
                        else if (vLoai == "VUANKN")
                        {
                            GDTTT_PCTP_VAKN_CHIDINH k = dt.GDTTT_PCTP_VAKN_CHIDINH.Where(x => x.ID == KQ_id).FirstOrDefault();
                            DTGDTTT.DT_PHANCONG_KETQUARow rk = objds.DT_PHANCONG_KETQUA.NewDT_PHANCONG_KETQUARow();
                            rk.TENDONVI = Session[ENUM_SESSION.SESSION_TENDONVI] + "";
                            rk.TUNGAY = ((DateTime)k.TUNGAY).ToString("dd/MM/yyyy");
                            rk.DENNGAY = ((DateTime)k.DENNGAY).ToString("dd/MM/yyyy");
                            rk.NGAYTHUCHIEN = ((DateTime)k.NGAYPHANCONG).ToString("dd/MM/yyyy HH:MM");
                            try
                            {
                                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == k.NGUOITHUCHIENID).FirstOrDefault();
                                if (oNSD != null)
                                {
                                    DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == oNSD.CANBOID).FirstOrDefault();
                                    if (oCB != null) rk.NGUOITHUCHIEN = oCB.HOTEN;
                                }
                            }
                            catch (Exception ex) { }

                            objds.DT_PHANCONG_KETQUA.AddDT_PHANCONG_KETQUARow(rk);
                            objds.AcceptChanges();
                            oDT = oPCBL.VAKN_GET_THEO_KETQUA_CHIDINHID(ToaAnID, k.TUNGAY, k.DENNGAY, 0, 0, 0, null, null, 0, KQ_id); //lấy kết quả hình thức phân công đơn chỉ định
                        }
                        Session["PHANCONG_KETQUA_HINH_THUC"] = "CHI_DINH";
                    }
                    #endregion

                    //DANH SÁCH đơn
                    int i = 0;
                    foreach (DataRow obj in oDT.Rows)
                    {
                        i += 1;
                        DTGDTTT.DT_PHANCONG_CHITIETRow rds = objds.DT_PHANCONG_CHITIET.NewDT_PHANCONG_CHITIETRow();
                        rds.NGUOIGUI = obj["NGUOIGUI_HOTEN"] + "";
                        if (obj["NGUOIGUI_HUYENID"] != null && !string.IsNullOrEmpty(obj["NGUOIGUI_HUYENID"].ToString()))
                        {
                            decimal HuyenID = Convert.ToDecimal(obj["NGUOIGUI_HUYENID"] ?? 0);
                            DM_HANHCHINH oTinh = dt.DM_HANHCHINH.Where(x => x.ID == HuyenID).FirstOrDefault() ?? new DM_HANHCHINH();
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

                    break;
            }
        }

        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            ddlThamphan.SelectedIndex = ddlToaXetXu.SelectedIndex = 0;
            txtSoTotrinh.Text = txtTotrinh_ngay.Text = txtTuNgay.Text = txtDenNgay.Text = txtNguoigui.Text = txtSoQDBA.Text = txtThuly_Ngay.Text = txtThuly_So.Text = "";
            LoadGrid();
        }

        private DataTable getDS()
        {
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");

            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            string strID = Request["kqid"] + "";

            decimal ToaRaBAQD = Convert.ToDecimal(ddlToaXetXu.SelectedValue),
               vThamphanID = Convert.ToDecimal(ddlThamphan.SelectedValue);
            string SoBAQD = txtSoQDBA.Text.Trim(), NgayBAQD = txtNgayBAQD.Text, NguoiGui = txtNguoigui.Text.Trim(),
                vSoThuly = txtThuly_So.Text.Trim(), vNgayThuly = txtThuly_Ngay.Text;
            string vSoTT = txtSoTotrinh.Text.Trim();
            string vNgayTT = txtTotrinh_ngay.Text.Trim();
            string vPC_tungay = txtTuNgay.Text;
            string vPC_denngay = txtDenNgay.Text;


            return oBL.DON_LICHSUPHANCONG(ToaAnID, vSoTT, vNgayTT, vPC_tungay, vPC_denngay, ToaRaBAQD, SoBAQD
                                            , NgayBAQD, NguoiGui, vNgayThuly, vSoThuly, vThamphanID, ddlLaiPhanCong.SelectedValue);
        }

    }
}