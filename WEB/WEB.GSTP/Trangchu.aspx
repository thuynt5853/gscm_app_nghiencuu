<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Trangchu.aspx.cs" Inherits="WEB.GSTP.Trangchu" %>

<%@ Register Src="~/UserControl/QLA/NhanAn.ascx" TagPrefix="uc1" TagName="NhanAn" %>
<%@ Register Src="~/UserControl/DKK/DangKyNhanVBTongDat.ascx" TagPrefix="uc1" TagName="DangKyNhanVBTongDat" %>
<%@ Register Src="~/UserControl/DKK/DonKKOnline.ascx" TagPrefix="uc1" TagName="DonKKOnline" %>
<%--Thong ke danh cho Chanh an--%>
<%@ Register Src="~/UserControl/TP/ThongKe.ascx" TagPrefix="uc1" TagName="ThongKe" %>
<%@ Register Src="~/QLAN/GDTTT/VuAn/BaoCao/uThongKe.ascx" TagPrefix="uc1" TagName="GDTThongKe" %>
<%@ Register Src="~/QLAN/BAOCAOCA/uThongKe_Chanhan.ascx" TagPrefix="uc1" TagName="GDTThongKe_Chanhan" %>
<%@ Register Src="~/UserControl/QLA/ThongKeVanBanTongDatChuaDangCTTDT.ascx" TagPrefix="uc1" TagName="VB_CTTCT_ChuaDang" %>
<%--Man hinh thong ke danh cho Trương phòng HCTP Tối cao--%>
<%@ Register Src="~/QLAN/GDTTT/Hoso/H_ThongKe.ascx" TagPrefix="uc1" TagName="H_ThongKe" %>
<%--Man hinh thong ke danh cho Trương phòng Hành chính tư pháp cấp cao--%>
<%@ Register Src="~/QLAN/GDTTT/Hoso/H_ThongKe_CC.ascx" TagPrefix="uc1" TagName="H_ThongKe_CC" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <uc1:H_ThongKe runat="server" ID="H_ThongKe" />
    <uc1:H_ThongKe_CC runat="server" ID="H_ThongKe_CC" />
    <uc1:ThongKe runat="server" ID="ThongKe" />
    <uc1:DonKKOnline runat="server" ID="DonKKOnline" />
    <uc1:DangKyNhanVBTongDat runat="server" ID="DangKyNhanVBTongDat" />
    <uc1:NhanAn runat="server" ID="NhanAn" />
    <uc1:GDTThongKe runat="server" ID="GDTThongKe"/>
    <uc1:GDTThongKe_Chanhan runat="server" ID="GDTThongKe_Chanhan"/>
    <uc1:VB_CTTCT_ChuaDang runat="server" ID="VB_CTTCT_ChuaDang1" />

    <style type="text/css">
            /*body {
                margin: 0 auto;
                padding: 0;
                font-family: arial;
                font-size: 13px;
                background-color: #ffffff;
            }*/

            .cmdThoat {
                margin-right: 100px;
            }

            .cmdCapNhat {
                border: 1px solid black;
                border-radius: 10px;
            }
        </style>

    <div runat="server" id="mymodal" style="display: none; visibility: hidden; position: absolute!important; "></div>
    <cc1:ModalPopupExtender ID="modal" BehaviorID="modal_ThongBao"
        runat="server" PopupControlID="pnCapnhat"
        TargetControlID="mymodal"
        
        BackgroundCssClass="modalBackground">
    </cc1:ModalPopupExtender>

    <asp:Panel ID="pnCapnhat" runat="server" align="center" CssClass="modalPopup" Style="display: none; height: 100%; width: 900px; top: 20px;">
        <div class="box_nd" style="width: 683px;padding-top:210px;">
                <div class="boder" style="padding: 10px;background-color: antiquewhite;border: 1px solid black; border-radius: 10px;">
                    <table class="table1">
                        <tr>
                            <td style="text-align: center;" id="Td1" runat="server">
                                <h1 id="H1" runat="server" style="font-size: 20px;color: red;">THÔNG BÁO
                                </h1>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center;" id="txtthongbao" runat="server">
                                <h1 id="lblthongbao" runat="server" style="font-size: 18px;">Mật khẩu hiện tại của bạn đã hết hạn theo quy định.
                                            Bạn cần thay đổi mật khẩu để tiếp tục truy cập phần mềm.
                                </h1>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center;" colspan="6">
                                <asp:Button ID="cmdCapNhat" runat="server" CssClass="buttoninput cmdCapNhat" OnClick="CapNhat_Click" Text="Cập nhật" />
                            </td>
                        </tr>
                    </table>
                </div>
        </div>
    </asp:Panel>
</asp:Content>




