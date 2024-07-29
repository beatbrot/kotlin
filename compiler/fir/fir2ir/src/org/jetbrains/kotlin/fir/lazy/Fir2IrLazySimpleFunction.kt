/*
 * Copyright 2010-2022 JetBrains s.r.o. and Kotlin Programming Language contributors.
 * Use of this source code is governed by the Apache 2.0 license that can be found in the license/LICENSE.txt file.
 */

package org.jetbrains.kotlin.fir.lazy

import org.jetbrains.kotlin.fir.backend.Fir2IrComponents
import org.jetbrains.kotlin.fir.backend.utils.contextReceiversForFunctionOrContainingProperty
import org.jetbrains.kotlin.fir.backend.generators.Fir2IrCallableDeclarationsGenerator
import org.jetbrains.kotlin.fir.backend.lazyMappedFunctionListVar
import org.jetbrains.kotlin.fir.backend.toIrType
import org.jetbrains.kotlin.fir.declarations.FirFunction
import org.jetbrains.kotlin.fir.declarations.FirRegularClass
import org.jetbrains.kotlin.fir.declarations.FirSimpleFunction
import org.jetbrains.kotlin.fir.initialSignatureAttr
import org.jetbrains.kotlin.ir.declarations.*
import org.jetbrains.kotlin.ir.declarations.lazy.lazyVar
import org.jetbrains.kotlin.ir.expressions.IrConstructorCall
import org.jetbrains.kotlin.ir.symbols.IrSimpleFunctionSymbol
import org.jetbrains.kotlin.ir.symbols.UnsafeDuringIrConstructionAPI
import org.jetbrains.kotlin.ir.types.IrType
import org.jetbrains.kotlin.name.Name
import org.jetbrains.kotlin.serialization.deserialization.descriptors.DeserializedContainerSource

@Suppress("DELEGATED_MEMBER_HIDES_SUPERTYPE_OVERRIDE") // K2 warning suppression, TODO: KT-62472
class Fir2IrLazySimpleFunction(
    c: Fir2IrComponents,
    startOffset: Int,
    endOffset: Int,
    origin: IrDeclarationOrigin,
    override val fir: FirSimpleFunction,
    private val firParent: FirRegularClass?,
    symbol: IrSimpleFunctionSymbol,
    parent: IrDeclarationParent,
    isFakeOverride: Boolean
) : AbstractFir2IrLazyFunction<FirSimpleFunction>(c, startOffset, endOffset, origin, symbol, parent, isFakeOverride) {
    init {
        symbol.bind(this)
        classifierStorage.preCacheTypeParameters(fir)
    }

    override var annotations: List<IrConstructorCall> by createLazyAnnotations()

    override var name: Name
        get() = fir.name
        set(_) = mutationNotSupported()

    override var returnType: IrType by lazyVar(lock) {
        fir.symbol.resolvedReturnTypeRef.toIrType(typeConverter)
    }

    override var contextReceiverParametersCount: Int = fir.contextReceiversForFunctionOrContainingProperty().size

    override var valueParameters: List<IrValueParameter> by lazyVar(lock) {
        declarationStorage.enterScope(this.symbol)

        buildList {
            callablesGenerator.addContextReceiverParametersTo(
                fir.contextReceiversForFunctionOrContainingProperty(),
                this@Fir2IrLazySimpleFunction,
                this@buildList
            )

            fir.valueParameters.mapIndexedTo(this) { index, valueParameter ->
                callablesGenerator.createIrParameter(
                    valueParameter, index + contextReceiverParametersCount, skipDefaultParameter = isFakeOverride
                ).apply {
                    this.parent = this@Fir2IrLazySimpleFunction
                }
            }
        }.apply {
            declarationStorage.leaveScope(this@Fir2IrLazySimpleFunction.symbol)
        }
    }

    override var overriddenSymbols: List<IrSimpleFunctionSymbol> by symbolsMappingForLazyClasses.lazyMappedFunctionListVar(lock) lazy@{
        if (firParent == null || parent !is Fir2IrLazyClass) return@lazy emptyList()

        val baseFunctionWithDispatchReceiverTag =
            lazyFakeOverrideGenerator.computeFakeOverrideKeys(firParent, fir.symbol)
        baseFunctionWithDispatchReceiverTag.map { (symbol, dispatchReceiverLookupTag) ->
            declarationStorage.getIrFunctionSymbol(symbol, dispatchReceiverLookupTag) as IrSimpleFunctionSymbol
        }
    }

    override val initialSignatureFunction: IrFunction? by lazy {
        val originalFunction = fir.initialSignatureAttr ?: return@lazy null
        val lookupTag = firParent?.symbol?.toLookupTag()

        // `initialSignatureFunction` is not called during fir2ir conversion
        @OptIn(UnsafeDuringIrConstructionAPI::class)
        declarationStorage.getIrFunctionSymbol(originalFunction, lookupTag).owner.also {
            check(it !== this) { "Initial function can not be the same as remapped function" }
        }
    }

    override val containerSource: DeserializedContainerSource?
        get() = fir.containerSource
}
