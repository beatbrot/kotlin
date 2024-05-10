/*
 * Copyright 2010-2024 JetBrains s.r.o. and Kotlin Programming Language contributors.
 * Use of this source code is governed by the Apache 2.0 license that can be found in the license/LICENSE.txt file.
 */

package org.jetbrains.sir.lightclasses.nodes

import org.jetbrains.kotlin.analysis.api.symbols.KtFunctionLikeSymbol
import org.jetbrains.kotlin.analysis.project.structure.KtModule
import org.jetbrains.kotlin.sir.*
import org.jetbrains.kotlin.sir.providers.SirSession
import org.jetbrains.kotlin.sir.providers.source.KotlinSource
import org.jetbrains.kotlin.sir.providers.source.Shortcut
import org.jetbrains.sir.lightclasses.SirFromKtSymbol
import org.jetbrains.sir.lightclasses.extensions.documentation
import org.jetbrains.sir.lightclasses.extensions.lazyWithSessions
import org.jetbrains.sir.lightclasses.extensions.getSirCallableKind
import org.jetbrains.sir.lightclasses.extensions.withSessions
import org.jetbrains.sir.lightclasses.utils.translateParameters
import org.jetbrains.sir.lightclasses.utils.translateReturnType

internal class SirFunctionFromKtSymbol(
    override val ktSymbol: KtFunctionLikeSymbol,
    override val ktModule: KtModule,
    override val sirSession: SirSession,
    private val isShortcut: Boolean = false,
) : SirFunction(), SirFromKtSymbol<KtFunctionLikeSymbol, SirFunction> {

    override val visibility: SirVisibility = SirVisibility.PUBLIC
    override val origin: SirOrigin by lazy {
        if (isShortcut) {
            Shortcut(this)
        } else {
            KotlinSource(ktSymbol)
        }
    }
    override val kind: SirCallableKind by lazy {
        ktSymbol.getSirCallableKind(parent)
    }
    override val name: String by lazyWithSessions {
        ktSymbol.sirDeclarationName()
    }
    override val parameters: List<SirParameter> by lazy {
        translateParameters()
    }
    override val returnType: SirType by lazy {
        translateReturnType()
    }
    override val documentation: String? by lazyWithSessions {
        ktSymbol.documentation()
    }

    override var parent: SirDeclarationParent
        get() = withSessions {
            if (isShortcut) {
                ktSymbol.getContainingModule().sirModule()
            } else {
                ktSymbol.getSirParent(analysisSession)
            }
        }
        set(_) = Unit

    override var body: SirFunctionBody? = null

    override val shortcut: SirFunction? by lazyWithSessions {
        val pkgFqName = ktSymbol.callableIdIfNonLocal?.packageName
            ?: return@lazyWithSessions null
        if (!pkgFqName.hasShortcut()) return@lazyWithSessions null
        SirFunctionFromKtSymbol(ktSymbol, ktModule, sirSession, isShortcut = true)
    }
}
