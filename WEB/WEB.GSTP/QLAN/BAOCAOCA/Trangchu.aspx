<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Trangchu.aspx.cs" Inherits="WEB.GSTP.QLAN.BAOCAOCA.Trangchu" %>

<%--Thong ke danh cho Chanh an--%>
<%@ Register Src="~/QLAN/BAOCAOCA/uThongKe_Chanhan.ascx" TagPrefix="uc1" TagName="GDTThongKe"%>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <uc1:GDTThongKe runat="server" ID="GDTThongKe"/>

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
                    </table>
                </div>
        </div>
    </asp:Panel>



<%--    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    $.ajax({
        type: "POST",
        url: "Trangchu.aspx/LoadDelayedData",  // URL cần phải trỏ đúng đến WebMethod
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (response) {
            console.log("Dữ liệu tải chậm đã xong: ", response);
        },
        error: function (xhr, status, error) {
            console.error("Lỗi khi tải dữ liệu chậm: ", xhr.responseText);
        }
    });
</script>--%>

</asp:Content>




